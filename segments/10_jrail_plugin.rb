class JrailsPlugin < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Installing JRails Plugin..."
  end
  
  def ending_message
    "JRails Plugin Installed"
  end
  
  def commit_message
    "installed jrails plugin"
  end
  
  def question
    "Would you like to install the JRails plugin? [Yn]"
  end
  
  def run_segment
    self.plugin 'jrails', :git => 'git://github.com/aaronchi/jrails.git'
  end
  
end
