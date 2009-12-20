# find easy way to force mysql

if `which unzip`.blank?
  exit 0 unless ask("Couldn't find 'unzip' to unpack jruby, continue? [N,y]") =~ /y/i
end

run "echo 'TODO' > README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"

# Freeze!
rake "rails:freeze:gems"

# Set up git repository
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-END
log/*.log
log/*.pid
*~
db/*.bkp
coverage
tmp
test/log
log/test
\\#*
.\\#*
apple_report_*.xls
.DS_Store
.svn
db/deep_test*
*_flymake.*
db/*.sqlite3
public/system
public/p/*
config/*.sphinx.conf
db/*sphinx
log/*.pid
log/culerity_page_errors
public/javascripts/all.js
public/stylesheets/all.css
public/images/upload
public/data
*.LCK
.sass-cache
END

gsub_file 'app/controllers/application_controller.rb', /#\s*(filter_parameter_logging :password)/, '\1'

load_template "http://github.com/expectedbehavior/rails_templates/raw/master/database_config.rb"

plugin 'db_setup', :git => 'git://github.com/expectedbehavior/db_setup.git'

require 'highline/import'
pw = HighLine.ask("gimme root sql password for db_setup: ") { |q| q.echo = false}
log "running", "db_setup"
run "script/db_setup -c --password #{pw}", false

git :init
git :add => '.'
git :commit => "-m 'initial commit'"




# Install submoduled plugins
# plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
plugin 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git'
plugin 'haml', :git => 'git://github.com/nex3/haml.git'
plugin 'exception_notification', :git => 'git://github.com/rails/exception_notification.git'

gsub_file 'app/controllers/application_controller.rb', /^(class ApplicationController.*)/, "\\1\n  include ExceptionNotifiable"

emails = %w(joel michael matt jason).map {|n| "#{n}@expectedbehavior.com" }.join(" ")
initializer "exception_notifier.rb", "ExceptionNotifier.exception_recipients = %w(#{emails})"

plugin 'bootstrapper', :git => 'git://github.com/sevenwire/bootstrapper.git'
generate :bootstrapper
gsub_file "db/bootstrap.rb", /^(Bootstrapper.for :test.*)/, "\\1\n  b.truncate_tables :all"

# plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git', :submodule => true
# plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git', :submodule => true
# plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git', :submodule => true
# plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git', :submodule => true
# plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git', :submodule => true
# plugin 'acts_as_taggable_redux', :git => 'git://github.com/monki/acts_as_taggable_redux.git', :submodule => true
# plugin 'aasm', :git => 'git://github.com/rubyist/aasm.git', :submodule => true
git :add => '.'
git :commit => "-m 'plugins'"

# Install all gems
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
gem 'cucumber', :env => "test"
gem 'cucumber-rails', :env => "test"
# gem "rubyist-aasm", :lib => "aasm", :source => "http://gems.github.com"

# gem 'ruby-openid', :lib => 'openid'
# gem 'sqlite3-ruby', :lib => 'sqlite3'
# gem 'hpricot', :source => 'http://code.whytheluckystiff.net'
# gem 'RedCloth', :lib => 'redcloth'
rake('gems:install', :sudo => true)
git :add => '.'
git :commit => "-m 'gems'"


load_template "http://github.com/expectedbehavior/rails_templates/raw/master/users.rb"

load_template "http://github.com/expectedbehavior/rails_templates/raw/master/authentication.rb"
 
# add routes
 
file "config/routes.rb", <<-END
ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.signup "signup", :controller => "users", :action => "new"
 
  map.resources :user_sessions
  map.resources :users
 
  map.root :users
 
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
END

git :add => '.'
git :commit => "-m 'initial routes'"


# # run migrations
rake "db:migrate"

git :add => '.'
git :commit => "-m 'schema'"





# get and unpack jruby into vendor
jruby_url = "http://jruby.kenai.com/downloads/1.4.0/jruby-bin-1.4.0.zip"
zip_name = File.basename(jruby_url)
jruby_folder = ""
inside "vendor" do
  open(jruby_url) do |remote_file|
    File.open(zip_name, "w") do |local_file|
      local_file.write remote_file.read
    end
  end
  
  run "unzip #{zip_name}"
  run "rm #{zip_name}"
  
  jruby_folder = Dir["jruby*"].first
end

# install celerity in jruby
run "vendor/#{jruby_folder}/bin/jruby -S gem install celerity"

# culerity needs jruby in the path
gsub_file "config/environment.rb", /\A/, <<-END
OSX_JAVA_HOME = "/System/Library/Frameworks/JavaVM.framework/Home"
UBUNTU_JAVA_HOME = "/usr/lib/jvm/java-1.5.0-sun"

if File.exists?(OSX_JAVA_HOME)
  ENV["JAVA_HOME"] = OSX_JAVA_HOME
elsif File.exists?(UBUNTU_JAVA_HOME)
  ENV["JAVA_HOME"] = UBUNTU_JAVA_HOME
end 

ENV['PATH'] ||= ""
ENV['PATH'] = ENV['PATH'] + ":" + File.join(File.dirname(__FILE__), '..', 'vendor', '#{jruby_folder}', 'bin')

END

file "cucumber.yml", <<-END
default: --require features --require lib --guess
END

plugin "culerity", :git => "git://github.com/langalex/culerity.git"
generate :cucumber
generate :culerity, "-f"

# webrat steps conflict with culerity
run "rm features/step_definitions/web_steps.rb"

# make cucumber restart the passenger test instance on every run
gsub_file "features/support/env.rb", /\Z/, <<-'END'

require 'fileutils'
FileUtils.touch "#{RAILS_ROOT}/tmp/restart.txt"
END

# print the number of the test before running it so we get an idea of progress
gsub_file "features/support/env.rb", /\Z/, <<-'END'

@@cucumber_cli_test_number = 1
Before do
  puts "--- TEST ##{@@cucumber_cli_test_number} ---"
  @@cucumber_cli_test_number += 1
end
END

# run the 'test' bootstrap before each test
gsub_file "features/support/env.rb", /\Z/, <<-'END'

require 'factory_girl'
require "#{RAILS_ROOT}/test/factories.rb"
require "#{RAILS_ROOT}/db/bootstrap.rb"

Before do
  Bootstrapper.run :test
end
END

# add this handy method to let us print the current page when a step failes
gsub_file "features/support/env.rb", /\Z/, <<-'END'

def print_page_on_error(*args, &block)
  begin
    yield
  rescue
    open_current_html_in_browser_
    raise
  end
end
END

file "test/factories.rb", <<-'END'
Factory.define(:user) do |u|
  u.sequence(:email) { |n| "email#{n}@example.com" }
  u.name { "John Doe" }
  u.password "password"
  u.password_confirmation "password"
end
END

file "features/login.feature", <<-END
Feature: Logging in
  In order to access the system
  As a user
  I want login to the system

  @1 @shouldwork @happy_case
  Scenario: Sign up and log into the system
    Given I am on the signup page
    When I fill in "Email" with "billy@example.com"
    And I fill in "Password" with "secret"
    And I fill in "Password confirmation" with "secret"
    And I press "Submit"
#     Then I should see "signup successful"
    When I view the login page
    And I fill in "Email" with "billy@example.com"
    And I fill in "Password" with "secret"
    And I press "Submit"
    And I should see "Login successful!"
END

["common_celerity_steps.rb", "model_create_steps.rb"].each do |filename|
  open "http://github.com/expectedbehavior/cucumber_culerity_step_definitions/raw/master/#{filename}" do |read_file|
    open "features/step_definitions/#{filename}", "w" do |write_file|
      write_file.write read_file.read
    end
  end
end

cucumber_paths = {
  "the signup page" => "signup_path",
  "the login page"  => "login_path",
}
cucumber_paths.each do |matcher, path|
  gsub_file "features/support/paths.rb", /(case page_name.*)/, "\\1\n    when /#{matcher}/\n      #{path}\n"
end

flash_erb = %Q{<p style="color: green"><%= flash[:notice] %></p>}
gsub_file "app/views/layouts/users.html.erb", /(#{Regexp.escape(flash_erb)})/, '<div>\1</div>'
