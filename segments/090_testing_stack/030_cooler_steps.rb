class AddCoolerSteps < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Adding cooler step definitions"
  end
  
  def ending_message
    "Cooler step definitions added"
  end
  
  def commit_message
    "cooler step definitions"
  end
  
  def run_segment
    self.git :rm => "features/step_definitions/web_steps.rb"
    self.git :rm => "features/step_definitions/culerity_steps.rb"
    
    self.plugin("cucumber_culerity_step_definitions", 
                :git => "git://github.com/expectedbehavior/cucumber_culerity_step_definitions.git")
    self.generate :cucumber_culerity_step_definitions, "-f"
  end
  
end
