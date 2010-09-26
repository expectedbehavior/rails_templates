require 'assertions'

require File.join("#{RAILS_ROOT}/lib", 'patches/active_support')
require File.join("#{RAILS_ROOT}/lib", 'patches/testrunner')

load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")

ActiveResource::Base.logger = Logger.new("#{RAILS_ROOT}/log/test.log") unless ENV['AR_TO_CONSOLE']
