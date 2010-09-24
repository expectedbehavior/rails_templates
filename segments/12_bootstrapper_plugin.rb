class BootstrapperPlugin < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Installing Bootstrapper Plugin..."
  end
  
  def ending_message
    "Bootstrapper Plugin Installed"
  end
  
  def commit_message
    "installed bootstrapper plugin"
  end
  
  def question
    "Would you like to install the Bootstrapper plugin? [Yn]"
  end
  
  def run_segment
    self.plugin 'bootstrapper', :git => 'git://github.com/expectedbehavior/bootstrapper.git'
    self.generate :bootstrapper
    self.gsub_file "db/bootstrap.rb", /^(Bootstrapper.for :test.*)/, "\\1\n  b.truncate_tables :all"
  end
  
end
