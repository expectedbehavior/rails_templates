class SetupExceptional < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Setting up exceptional"
  end
  
  def ending_message
    "Exceptional configured"
  end
  
  def commit_message
    "exceptional configured"
  end
  
  def question
    "Would you like to configure exceptional? [Yn]"
  end
  
  def run_segment
    key = HighLine.ask("exceptional key for application: ")
    self.run "exceptional install #{key}"
    self.append_file File.join('config', 'environment.rb', 'exceptional.rb')
  end
  
end
