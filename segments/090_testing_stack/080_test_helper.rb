class AddToTestHelper < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Adding useful stuff to test helper"
  end
  
  def ending_message
    "Useful stuff added to test helper"
  end
  
  def commit_message
    "useful stuff for test helper"
  end
  
  def run_segment
    self.copy_file File.join("lib", "patches", "active_support.rb")
    self.copy_file File.join("lib", "patches", "testrunner.rb")
    self.copy_file File.join("lib", "patches", "redgreen.rb")
    self.copy_file File.join("lib", "patches", "float.rb")
    self.copy_file File.join("lib", "test_unit_slow.rb")
    self.append_file File.join("test", "test_helper.rb", "useful_stuff.rb")
  end
  
end
