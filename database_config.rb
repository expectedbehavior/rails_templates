require 'pwfoo'

log "updating", "database.yml"

# fix up database.yml
gsub_file "config/database.yml", /password:/ do |match|
  pwd = PwFoo::GeneratePassword.new(16).generate_with_min_strength 80
  "password: #{pwd}"
end

app_name = File.basename(FileUtils.pwd)
env = ""
mysql_username_size_limit = 16
random_string_size = 4
# take first 4 chars of env, except dev
length_converter = Hash.new {|hash, key| hash[key] = key[0, 4]}.merge("development" => "dev")
# look through the file for the username field, keeping track of the env along the way to use in the username
gsub_file "config/database.yml", /(^\w+:|username:.*)/ do |match|
  if match =~ /username/
    short_env = length_converter[env]
    username = "#{app_name}_#{short_env}"
    if username.size > mysql_username_size_limit # stupid mysql
      random_string = PwFoo::GeneratePassword.new(random_string_size).generate + "_"
      remaining_length = mysql_username_size_limit - random_string.size - short_env.size
      app_name_part = app_name[0, remaining_length]
      username = "#{app_name_part}#{random_string}#{short_env}"
    end
    "username: #{username}"
  else
    env = match.gsub(/:.*/, '')
    match
  end
end
