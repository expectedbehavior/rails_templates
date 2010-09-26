class InstallForgotPassword < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Installing forgot password stack..."
  end
  
  def ending_message
    "Forgot password stack installed"
  end
  
  def commit_message
    "forgot password stack"
  end
  
  def question
    "Would you like to install the forgot password stack? [Yn]"
  end
  
  def run_segment
    
    self.plugin("active_mailer", :git => "git://github.com/expectedbehavior/active_mailer.git")
    
    self.append_string(File.join('config', 'environment.rb'), "EMAIL_FROM_ADDRESS = 'support@expectedbehavior.com'")
    
    config = YAML.load(File.open(".webconfig.yml").read)
    [:development, :test, :production].each do |env|
      host = "#{config[env][:server_names].first}:#{config[env][:port]}"
      str = (env == :production ? "" : "config.action_mailer.delivery_method = :test\n")
      
      self.append_string(File.join('config', 'environments', "#{env}.rb"), 
                         str + "config.action_mailer.default_url_options = {:host => \"#{host}\"}")
    end
    
    self.copy_file File.join('db', 'migrate', '20100101000010_active_mailer_migration.rb')
    self.copy_file File.join('db', 'migrate', '20100101000020_create_forgot_password_emails.rb')
    
    self.copy_template(:src => File.join('app', 'models', 'forgot_password_email.rb'), 
                       :assigns => { :app_name => self.app_name.titleize })
    
    self.copy_file File.join('app', 'controllers', 'password_resets_controller.rb')
    
    self.copy_file File.join('app', 'views', 'active_mailer', 'base', 'default_action_mailer', 'forgot_password_email.haml')
    
    self.copy_file File.join('app', 'views', 'password_resets', 'new.html.haml')
    self.copy_file File.join('app', 'views', 'password_resets', 'edit.html.haml')
    
    self.append_string(File.join('app', 'views', 'user_sessions', 'new.html.haml'), 
                       "= link_to 'Forgot your password?', [:new, :password_reset]")
    
    self.route("map.resources :password_resets, :only => [ :new, :create, :edit, :update ]")
    
    self.copy_file File.join('features', 'forgot_password.feature')
    self.copy_file File.join('features', 'step_definitions', 'forgot_password_steps.rb')
  end
  
end
