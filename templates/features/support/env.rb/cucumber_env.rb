require 'database_cleaner'
require 'database_cleaner/cucumber'
DatabaseCleaner.strategy = :truncation, { :only => [] }

require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'

require 'fileutils'
FileUtils.touch "#{RAILS_ROOT}/tmp/restart.txt"

@@cucumber_cli_test_number = 1
Before do
  puts
  puts "--- TEST ##{@@cucumber_cli_test_number} ---"
  @@cucumber_cli_test_number += 1
end

require 'factory_girl'
require "#{RAILS_ROOT}/test/factories.rb"
require "#{RAILS_ROOT}/db/bootstrap.rb"

Before do
  Bootstrapper.run :test
end
