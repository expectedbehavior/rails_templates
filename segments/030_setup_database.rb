require 'pwfoo'

class SetupDatabase < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Setting up the database"
  end
  
  def ending_message
    "Database configured"
  end
  
  def commit_message
    "database configured"
  end
  
  def socket_erb
    'socket: <%= %w(/var/run/mysqld/mysqld.sock /tmp/mysql.sock /var/lib/mysql/mysql.sock).detect {|p| File.exist? p} %>'
  end
  
  def run_segment
    self.gsub_file "config/database.yml", /password:/ do |match|
      pwd = PwFoo::GeneratePassword.new(16).generate_with_min_strength 80
      "password: #{pwd}"
    end

    env = ""
    mysql_username_size_limit = 16
    random_string_size = 4
    # take first 4 chars of env, except dev
    length_converter = Hash.new {|hash, key| hash[key] = key[0, 4]}.merge("development" => "dev")
    # look through the file for the username field, keeping track of the env along the way to use in the username
    self.gsub_file "config/database.yml", /(^\w+:|username:.*)/ do |match|
      if match =~ /username/
        short_env = length_converter[env]
        username = "#{app_name}_#{short_env}"
        if username.size > mysql_username_size_limit # stupid mysql
          random_string = PwFoo::GeneratePassword.new(random_string_size).generate + "_"
          remaining_length = mysql_username_size_limit - random_string.size - short_env.size
          app_name_part = self.app_name[0, remaining_length]
          username = "#{app_name_part}#{random_string}#{short_env}"
        end
        "username: #{username}"
      else
        env = match.gsub(/:.*/, '')
        match
      end
    end

    self.gsub_file "config/database.yml", /(socket:.*)/, self.socket_erb
    
    self.plugin 'production_data', :git => 'git://github.com/expectedbehavior/production_data.git'
    
    pw = HighLine.ask("gimme root sql password for db_setup: ") { |q| q.echo = false }
    self.run "script/db_setup -c --password #{pw}", false
  end
  
end
