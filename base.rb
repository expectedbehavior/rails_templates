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

#commit rails, quietly
git :init
git :add => '.'
git :commit => "-q -m 'initial commit'"


# Install submoduled plugins
# plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
plugin 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git'
plugin 'haml', :git => 'git://github.com/nex3/haml.git'
plugin 'exception_notification', :git => 'git://github.com/rails/exception_notification.git'

gsub_file 'app/controllers/application_controller.rb', /^(class ApplicationController.*)/, "\\1\n  include ExceptionNotifiable"

emails = %w(joel michael matt jason).map {|n| "#{n}@expectedbehavior.com" }.join(" ")
initializer "exception_notifier.rb", "ExceptionNotifier.exception_recipients = %w(#{emails})"

plugin 'bootstrapper', :git => 'git://github.com/expectedbehavior/bootstrapper.git'
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
gem "factory_girl", :source => "http://gemcutter.org"
gem 'cucumber', :env => "test"
gem 'cucumber-rails', :env => "test"
# gem "rubyist-aasm", :lib => "aasm", :source => "http://gems.github.com"

# gem 'ruby-openid', :lib => 'openid'
# gem 'sqlite3-ruby', :lib => 'sqlite3'
# gem 'hpricot', :source => 'http://code.whytheluckystiff.net'
# gem 'RedCloth', :lib => 'redcloth'
install_gems_using_sudo = nil != (/[Yy]/ =~ HighLine.ask("install gems using sudo?[Yn]") {|q| q.default = 'Y'; q.validate = /[YyNn]/})
rake('gems:install', :sudo => install_gems_using_sudo)
rake('gems:install', :env => "test", :sudo => install_gems_using_sudo)
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


# run migrations
rake "db:migrate"

git :add => '.'
git :commit => "-m 'schema'"

load_template "http://github.com/expectedbehavior/rails_templates/raw/master/cucumber_culerity.rb"

# run migrations in test mode
rake "db:test:clone_structure"
rake "db:test:prepare"
git :add => '.'
git :commit => "-m 'schema (test)'"

puts "\nTo test, the following commands inside your new rails app's root dir:\n  cucumber features"
