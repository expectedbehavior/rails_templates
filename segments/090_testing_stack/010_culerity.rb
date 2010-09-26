class InstallCulerity < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Installing culerity"
  end
  
  def ending_message
    "Culerity installed"
  end
  
  def commit_message
    "basic cucumber and culerity"
  end
  
  def run_segment
    self.copy_file File.join("config", "initializers", "capybara.rb")
    self.generate :cucumber
    self.generate :culerity, "-f"

    # cucumber warns you about transactional fixtures if you don't cache classes, and it doesn't matter to us, so switch it
    self.gsub_file "config/environments/culerity.rb", /(config.cache_classes = )false/, '\1true'
    
    # get rid of those gem lines, we are on bundler
    self.gsub_file "config/environments/culerity.rb", /config.gem/, "# config.gem"
    self.gsub_file "config/environments/cucumber.rb", /config.gem/, "# config.gem"
  end
  
end
