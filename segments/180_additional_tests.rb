class InstallAdditionalTests < TemplateSegment
  def required?
    true
  end
  
  def starting_message
    "Installing Additional Tests"
  end
  
  def ending_message
    "additional tests installed"
  end
  
  def commit_message
    "application_helper testing"
  end
  
  def run_segment
    self.copy_file File.join("test", "unit", "application_helper_test.rb")
  end
end
