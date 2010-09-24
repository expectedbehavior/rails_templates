class ConnectionFix < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Installing connection fix patch..."
  end
  
  def ending_message
    "Connection fix patch installed"
  end
  
  def commit_message
    "connection fix patch"
  end
  
  def question
    "Would you like to install the connection fix patch? [Yn]"
  end
  
  def run_segment
    self.copy_file File.join('config', 'initializers', 'connection_fix.rb')
  end
  
end
