class AddPatches < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Adding common patches"
  end
  
  def ending_message
    "Common patches added"
  end
  
  def commit_message
    "common rails patches added"
  end
  
  def question
    "Would you like to add the common rails patches (String - {down_under, filename_sanitize}, ARes.logger=AR.logger, field_error_proc change to be less obnoxious)? [Yn]"
  end
  
  def run_segment
    self.copy_file File.join('lib', 'patches', 'string.rb')
    self.copy_file File.join("test", "unit", "string_path_test.rb")
    self.append_file File.join('config', 'environment.rb', 'add_patches.rb')
  end
  
end
