class InstallJRuby < TemplateSegment
  
  def required?
    false
  end
  
  def bail_if_skipped?
    true
  end
  
  def starting_message
    "Installing JRuby"
  end
  
  def ending_message
    "JRuby installed"
  end
  
  def commit_message
    "jruby"
  end
  
  def question
    "Would you like to install the jruby testing stack? [Yn]"
  end
  
  def run_segment
    self.log 'copy', 'vendor/jruby-1.4.0'
    FileUtils.cp_r(File.join(self.templates_path, 'vendor', 'jruby-1.4.0'), File.join('.', 'vendor'))
    self.gsub_after(/(# Be sure to restart your server when you modify this file)/, 
                    File.join("config", "environment.rb", "jruby.rb"))
  end
  
end
