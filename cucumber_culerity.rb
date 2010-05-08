# get and unpack jruby into vendor

#jruby_url = "http://jruby.kenai.com/downloads/1.4.0/jruby-bin-1.4.0.zip"
#zip_name = File.basename(jruby_url)
zip_name = "jruby-bin-1.4.0.zip"
jruby_folder = ""

# require 'rubygems'
# require 'ruby-debug'
# debugger

# jruby_template_path   = "#{File.dirname(template)}/vendor/jruby-bin-1.4.0.zip"
jruby_template_path   = "./vendor/jruby-bin-1.4.0.zip"
puts jruby_template_path
inside "vendor" do
# puts "downloading jruby from #{jruby_url}"
  FileUtils.copy_file(jruby_template_path, ".")

#   open(jruby_path) do |remote_file|
#     File.open(zip_name, "w") do |local_file|
#       local_file.write remote_file.read
#     end
#   end
  
  run "unzip #{zip_name}"
  run "rm #{zip_name}"
  
  jruby_folder = Dir["jruby*"].first
end


announce("commit the 8bil files from jruby, quietly")
git :add => '.'
git :commit => "-q -m 'jruby'"

announce("install celerity in jruby")
run "vendor/#{jruby_folder}/bin/jruby -S gem install celerity"

git :add => '.'
git :commit => "-m 'celerity installed in jruby'"

plugin "culerity", :git => "git://github.com/langalex/culerity.git"
generate :cucumber
generate :culerity, "-f"

# cucumber warns you about transactional fixtures if you don't cache classes, and it doesn't matter to us, so switch it
gsub_file "config/environments/culerity.rb", /(config.cache_classes = )false/, '\1true'

git :add => '.'
git :commit => "-m 'basic cucumber and culerity'"

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

git :add => '.'
git :commit => "-m 'put jruby in the path so culerity can find it'"

file "cucumber.yml", <<-END
default: --require features --require lib --guess
END

git :add => '.'
git :commit => "-m 'cucumber.yml'"

# webrat steps conflict with culerity, and we've got cooler step defs than culerity comes with
git :rm => "features/step_definitions/web_steps.rb"
git :rm => "features/step_definitions/culerity_steps.rb"

# drop in our step defs
plugin "cucumber_culerity_step_definitions", :git => "git://github.com/expectedbehavior/cucumber_culerity_step_definitions.git"
generate :cucumber_culerity_step_definitions, "-f"

git :add => '.'
git :commit => "-m 'cooler step definitions'"

# setup cucumber dependencies
append_file "features/support/env.rb", <<-'END'

require 'database_cleaner'
require 'database_cleaner/cucumber'
DatabaseCleaner.strategy = :truncation

require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'
END

# make cucumber restart the passenger test instance on every run
append_file "features/support/env.rb", <<-'END'

require 'fileutils'
FileUtils.touch "#{RAILS_ROOT}/tmp/restart.txt"
END

# print the number of the test before running it so we get an idea of progress
append_file "features/support/env.rb", <<-'END'

@@cucumber_cli_test_number = 1
Before do
  puts "--- TEST ##{@@cucumber_cli_test_number} ---"
  @@cucumber_cli_test_number += 1
end
END

# run the 'test' bootstrap before each test
append_file "features/support/env.rb", <<-'END'

require 'factory_girl'
require "#{RAILS_ROOT}/test/factories.rb"
require "#{RAILS_ROOT}/db/bootstrap.rb"

Before do
  Bootstrapper.run :test
end
END

# add this handy method to let us print the current page when a step failes
append_file "features/support/env.rb", <<-'END'

def print_page_on_error(*args, &block)
  begin
    yield
  rescue
    open_current_html_in_browser_
    raise
  end
end
END

git :add => '.'
git :commit => "-m 'add handy stuff to cucumber env.rb'"

file "test/factories.rb", <<-'END'
Factory.define(:user) do |u|
  u.sequence(:email) { |n| "email#{n}@example.com" }
  u.name { "John Doe" }
  u.password "password"
  u.password_confirmation "password"
end
END

git :add => '.'
git :commit => "-m 'user factory for upcoming test'"

cucumber_paths = {
  "the signup page" => "signup_path",
  "the login page"  => "login_path",
}
cucumber_paths.each do |matcher, path|
  gsub_file "features/support/paths.rb", /(case page_name.*)/, "\\1\n    when /#{matcher}/\n      #{path}\n"
end

git :add => '.'
git :commit => "-m 'add some paths we will need for cucumber'"

file "features/login.feature", <<-END
Feature: Logging in
  In order to access the system
  As a user
  I want to login to the system

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

git :add => '.'
git :commit => "-m 'first test'"
