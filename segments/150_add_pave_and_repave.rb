class AddPaveAndRepave < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Adding pave and repave tasks..."
  end
  
  def ending_message
    "Added pave and repave tasks."
  end
  
  def commit_message
    "pave and repave tasks"
  end
  
  def question
    "Would you like to add the pave and repave tasks? [Yn]"
  end
  
  def run_segment
    self.copy_file File.join("lib", "tasks", "pave.rake")
  end
  
end
