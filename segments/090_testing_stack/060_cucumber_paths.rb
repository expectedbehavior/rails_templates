class CucumberPaths < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Updating cucumber paths"
  end
  
  def ending_message
    "Cucumber paths updated"
  end
  
  def commit_message
    "add some paths we will need for cucumber"
  end
  
  def run_segment
    cucumber_paths = {
      "the signup page" => "signup_path",
      "the login page"  => "login_path",
    }
    cucumber_paths.each do |matcher, path|
      self.gsub_file "features/support/paths.rb", /(case page_name.*)/, "\\1\n    when /#{matcher}/\n      #{path}\n"
    end
  end
  
end
