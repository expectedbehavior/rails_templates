class InstallFixYouSomeAddressBar < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Installing fix you some address bar plugin..."
  end
  
  def ending_message
    "Fix you some address bar plugin installed."
  end
  
  def commit_message
    "fix you some address bar plugin"
  end
  
  def question
    "Would you like to install the fix you some address bar plugin? [Yn]"
  end
  
  def run_segment
    self.plugin 'fix_you_some_address_bar', :git => 'git@github.com:expectedbehavior/fix_you_some_address_bar.git'
  end
  
end
