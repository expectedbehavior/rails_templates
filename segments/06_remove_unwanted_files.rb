class RemoveUnwantedFiles < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Removing default files we don't want"
  end
  
  def ending_message
    "Unwanted files removed"
  end
  
  def commit_message
    "unwanted files removed"
  end
  
  def run_segment
    self.run "echo 'TODO' > README"
    self.run "rm public/index.html"
    self.run "rm public/favicon.ico"
    self.run "rm public/robots.txt"
  end
  
end
