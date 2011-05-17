class SetupRcov < TemplateSegment
  def required?
    true
  end
  
  def starting_message
    "Setting up rcov with cukes option"
  end
  
  def ending_message
    "rcov setup"
  end
  
  def commit_message
    "rcov options"
  end
  
  def run_segment
    self.plugin 'rcov_rails', :git => 'https://github.com/matthewrudy/rcov_rails.git'
    self.gsub_file("lib/tasks/cucumber.rake", /t\.profile = 'default'/,
                   "t.profile = 'default'\n        t.cucumber_opts = '--format pretty'\n        t.rcov = true")
    
  end
end
