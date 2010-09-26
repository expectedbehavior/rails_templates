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
    
    self.copy_file File.join('config', 'routes.rb')
    
    self.copy_file File.join('db', 'migrate', '20100101000000_create_users.rb')
    
    self.copy_file File.join('app', 'models', 'user.rb')
    self.copy_file File.join('app', 'models', 'user_session.rb')
    
    self.gsub_after(/^(class ApplicationController < ActionController::Base.*)/, 
                    File.join('app', 'controllers', 'application_controller.rb', 'user_stack_03.rb'))
    
    self.gsub_before(/(end)\s*\Z/, 
                    File.join('app', 'controllers', 'application_controller.rb', 'user_stack_01.rb'))
    
    self.gsub_file(File.join('app', 'controllers', 'application_controller.rb'), /#\s*(filter_parameter_logging :password)/,
              File.read(File.join(self.templates_path, 'app', 'controllers', 'application_controller.rb', 'user_stack_02.rb')))
    
    self.copy_file File.join('app', 'controllers', 'home_controller.rb')
    self.copy_file File.join('app', 'controllers', 'users_controller.rb')
    self.copy_file File.join('app', 'controllers', 'user_sessions_controller.rb')
    
    self.copy_file File.join('app', 'views', 'home', 'index.html.haml')
    self.copy_file File.join('app', 'views', 'layouts', 'application.html.haml')
    self.copy_file File.join('app', 'views', 'users', 'show.html.haml')
    self.copy_file File.join('app', 'views', 'users', 'new.html.haml')
    self.copy_file File.join('app', 'views', 'users', 'edit.html.haml')
    self.copy_file File.join('app', 'views', 'users', '_form.html.haml')
    self.copy_file File.join('app', 'views', 'user_sessions', 'new.html.haml')
    
  end
  
end