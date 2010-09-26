class AddCucumberYml < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Adding cucumber.yml file"
  end
  
  def ending_message
    "cucumber.yml file added"
  end
  
  def commit_message
    "cucumber.yml"
  end
  
  def run_segment
    self.copy_file File.join("config", "cucumber.yml")
  end
  
end
