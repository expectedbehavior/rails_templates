class AddFactories < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Adding default factories"
  end
  
  def ending_message
    "Default factories added"
  end
  
  def commit_message
    "user factory for upcoming test"
  end
  
  def run_segment
    self.copy_file File.join("test", "factories.rb")
  end
  
end
