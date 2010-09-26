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
    "common string patches added"
  end
  
  def question
    "Would you like to add the common string patches? [Yn]"
  end
  
  def run_segment
    self.copy_file File.join('lib', 'patches', 'string.rb')
    self.append_file File.join('config', 'environment.rb', 'add_patches.rb')
  end
  
end
p
