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
    self.gsub_file File.join("features", "support", "env.rb"), /ENV\["RAILS_ENV"\] \|\|\= "culerity"/, 'ENV["RAILS_ENV"] = "test"'
    self.append_file File.join("features", "support", "env.rb", "cucumber_env.rb")
    
    if File.exists?(".webconfig.yml")
      test_port = YAML.load(File.open(".webconfig.yml").read)[:test][:port]
      self.append_string(File.join("features", "support", "env.rb"), "$port = #{test_port}")
    end
  end
  
end
