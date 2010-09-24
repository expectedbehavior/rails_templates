class AddDefaultFeature < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Adding default feature"
  end
  
  def ending_message
    "Default feature added"
  end
  
  def commit_message
    "first test"
  end
  
  def run_segment
    self.copy_file File.join("features", "login.feature")
  end
  
end
