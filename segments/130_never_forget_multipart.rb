class InstallNeverForgetMultipart < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Installing never forget multipart plugin..."
  end
  
  def ending_message
    "Never forget multipart plugin installed."
  end
  
  def commit_message
    "never forget multipart plugin"
  end
  
  def question
    "Would you like to install the never forget multipart plugin? [Yn]"
  end
  
  def run_segment
    self.plugin 'never_forget_multipart', :git => 'git://github.com/dolzenko/never_forget_multipart.git'
  end
  
end
