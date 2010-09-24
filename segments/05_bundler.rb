class BundlerSetup < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Finishing bundler setup..."
  end
  
  def ending_message
    "Bundler setup finished"
  end
  
  def commit_message
    "bundler setup"
  end
  
  def run_segment
    self.copy_file(File.join("config", "preinitializer.rb"))
    self.gsub_before(/(# All that for this)/, File.join("config", "boot.rb", "bundler.rb"))
  end
  
end
