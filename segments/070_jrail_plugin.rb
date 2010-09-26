class JrailsPlugin < TemplateSegment
  
  def required?
    true
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
  
  def run_segment
    self.plugin 'jrails', :git => 'git://github.com/aaronchi/jrails.git'
  end
  
end
