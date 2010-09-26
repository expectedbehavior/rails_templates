 begin
   require 'heroku_san/tasks'
 rescue LoadError
   STDERR.puts "Run `rake gems:install` to install heroku_san"
 end
