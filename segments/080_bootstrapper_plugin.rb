class BootstrapperPlugin < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Configuring Bootstrapper Gem..."
  end
  
  def ending_message
    "Bootstrapper Gem Configured"
  end
  
  def commit_message
    "bootstrapper config"
  end
  
  def question
    "Would you like to configure the bootstrapper gem? [Yn]"
  end
  
  def run_segment
#     self.plugin 'bootstrapper', :git => 'git://github.com/expectedbehavior/bootstrapper.git'
    self.generate :bootstrapper
    self.gsub_file "db/bootstrap.rb", /^(Bootstrapper.for :test.*)/, "\\1\n  b.truncate_tables :all"
  end
  
end
