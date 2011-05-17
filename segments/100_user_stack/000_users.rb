class InstallUserStack < TemplateSegment
  
  def required?
    false
  end
  
  def bail_if_skipped?
    true
  end
  
  def starting_message
    "Installing user stack"
  end
  
  def ending_message
    "User stack installed"
  end
  
  def commit_message
    "user stack"
  end
  
  def question
    "Would you like to install the user stack? [Yn]"
  end
  
  def run_segment
    
    self.copy_file File.join('db', 'migrate', '20100101000000_create_users.rb')
    
    self.copy_file File.join('app', 'models', 'user.rb')
    self.copy_file File.join('app', 'models', 'user_session.rb')
    
    self.gsub_after(/^(class ApplicationController < ActionController::Base.*)/, 
                    File.join('app', 'controllers', 'application_controller.rb', 'user_stack_03.rb'))
    
    self.gsub_before(/(end)\s*\Z/, 
                    File.join('app', 'controllers', 'application_controller.rb', 'user_stack_01.rb'))
    
    self.gsub_file(File.join('app', 'controllers', 'application_controller.rb'), /#\s*(filter_parameter_logging :password)/,
              File.read(File.join(self.templates_path, 'app', 'controllers', 'application_controller.rb', 'user_stack_02.rb')))
    
    self.gsub_file(File.join('app', 'controllers', 'home_controller.rb'), 
                   /def index/, "skip_before_filter :require_user\n\n  def index")
    
    self.copy_file File.join('app', 'views', 'layouts', '_header.html.haml')
    
    self.copy_file File.join('app', 'helpers', 'application_helper.rb')
    
    self.copy_file File.join('app', 'controllers', 'users_controller.rb')
    self.copy_file File.join('app', 'controllers', 'profile_controller.rb')
    self.copy_file File.join('app', 'controllers', 'user_sessions_controller.rb')
    
    self.copy_file File.join('app', 'views', 'users', 'new.html.haml')
    self.copy_file File.join('app', 'views', 'users', '_form.html.haml')
    self.copy_file File.join('app', 'views', 'profile', 'show.html.haml')
    self.copy_file File.join('app', 'views', 'profile', 'edit.html.haml')
    self.copy_file File.join('app', 'views', 'user_sessions', 'new.html.haml')
    
    self.route 'map.signup "signup", :controller => "users",         :action => "new"'
    self.route 'map.login  "login",  :controller => "user_sessions", :action => "new"'
    self.route 'map.logout "logout", :controller => "user_sessions", :action => "destroy"'
    
    self.route 'map.resources :user_sessions, :only => [ :new, :create, :destroy ]'
    self.route 'map.resources :users, :only => [:new, :create]'
    self.route 'map.resource  :profile, :only => [:show, :edit, :update], :controller => "profile"'

    self.copy_file File.join("test", "unit", "user_test.rb")
    self.copy_file File.join("test", "functional", "users_controller_test.rb")
    self.copy_file File.join("test", "functional", "profile_controller_test.rb")
    self.copy_file File.join("features", "login.feature")
    self.copy_file File.join("features", "profile.feature")
    self.copy_file File.join("features", "step_definitions", "project_steps.rb")
  end
  
end
