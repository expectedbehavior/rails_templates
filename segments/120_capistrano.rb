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
    self.copy_file File.join('config', 'deploy.rb') #figure out a way to do easy replacement in this file
    self.copy_file File.join('Capfile')
  end
  
end
