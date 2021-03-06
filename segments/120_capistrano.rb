class SetupCapistrano < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Setting up capistrano..."
  end
  
  def ending_message
    "Capistrano setup."
  end
  
  def commit_message
    "capistrano"
  end
  
  def question
    "Would you like to setup capistrano? [Yn]"
  end
  
  def run_segment
    self.copy_template(:src => File.join('config', 'deploy.rb'), :assigns => { :app_name => self.app_name })
    self.copy_file File.join('Capfile')
    self.copy_file File.join('lib','tasks','sass.rake')
  end
  
end
