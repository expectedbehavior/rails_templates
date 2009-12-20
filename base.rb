# find easy way to force mysql
# database.yml should have a real username and randomly generated password
# should install the db_setup script

# install exception notifier and set it up
# turn on protect_forgery since we never want it

require 'pwfoo'

run "echo 'TODO' > README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"

# Freeze!
rake "rails:freeze:gems"

#load_template "http://github.com/systematic/rails_templates/raw/master/initial_git_commit.rb

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

load_template "http://github.com/expectedbehavior/rails_templates/raw/master/database_config.rb"

git :init
git :add => '.'
git :commit => "-m 'initial commit'"




# Install submoduled plugins
# plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
plugin 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git'
plugin 'haml', :git => 'git://github.com/nex3/haml.git'
plugin 'db_setup', :git => 'git://github.com/expectedbehavior/db_setup.git'

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
# gem "rubyist-aasm", :lib => "aasm", :source => "http://gems.github.com"

# gem 'ruby-openid', :lib => 'openid'
# gem 'sqlite3-ruby', :lib => 'sqlite3'
# gem 'hpricot', :source => 'http://code.whytheluckystiff.net'
# gem 'RedCloth', :lib => 'redcloth'
rake('gems:install', :sudo => true)
git :add => '.'
git :commit => "-m 'gems'"

# generate("authenticated", "user session --include-activation  --aasm")
# git :add => '.'
# git :commit => "-m 'user authentication'"

generate(:scaffold, "User", "email:string", "crypted_password:string", "password_salt:string", "persistence_token:string") 
gsub_file "app/models/user.rb", /^(class User.*)/, "\\1\n  acts_as_authentic"

run "rm app/views/users/*.erb"

file "app/controllers/application_controller.rb", <<-END
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
 
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
 
  helper_method :current_user
 
  private
 
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
 
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
 
end
END

file "app/views/users/index.haml", <<-END
%h2 User List
%ul
- @users.each do |u|
  %li= u.email
END
 
file "app/views/users/edit.haml", <<-END
%h2 Edit Profile
= render :partial => 'form'
END
 
file "app/views/users/new.haml", <<-END
%h2 New Profile
= render :partial => 'form'
END
 
file "app/views/users/_form.haml", <<-END
- form_for @user do |f|
  = f.error_messages
  %p
    = f.label :email
    %br
    = f.text_field :email
  %p
    = f.label :password
    %br
    = f.password_field :password
  %p
    = f.label :password_confirmation
    %br
    = f.password_field :password_confirmation
  %p
    = f.submit "Submit"
END



generate(:session, "user_session")
generate(:controller, "user_sessions")
# run "cp #{@template}/user_sessions_controller.rb app/controllers/user_sessions_controller.rb"
file "app/controllers/user_sessions_controller.rb", <<-END
class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to root_path
    else
      flash[:error] = "Login failed."
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to new_user_session_url
  end
  
end
END

file "app/views/user_sessions/new.haml", <<-END
%h2 Login
- form_for @user_session do |f|
  = f.error_messages
  %p
    = f.label :email
    %br
    = f.text_field :email
  %p
    = f.label :password
    %br
    = f.password_field :password
  %p
    = f.submit "Submit"
END
 
# add routes
 
file "config/routes.rb", <<-END
ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
 
  map.resources :user_sessions
  map.resources :users
 
  map.root :users
 
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
END
 

require 'highline/import'
pw = HighLine.ask("gimme root sql password for db_setup: ") { |q| q.echo = false}
log "running db_setup"
run "script/db_setup -c --password #{pw}", false

# # run migrations
rake "db:migrate"
