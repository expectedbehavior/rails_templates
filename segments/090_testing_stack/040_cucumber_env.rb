class CucumberEnv < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Updating cucumber env.rb"
  end
  
  def ending_message
    "Cucumber env.rb updated"
  end
  
  def commit_message
    "add handy stuff to cucumber env.rb"
  end
  
  def run_segment
    self.append_file File.join("features", "support", "env.rb", "cucumber_env.rb")
  end
  
end
