class SetupGit < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Creating git repo..."
  end
  
  def ending_message
    "Git repo created."
  end
  
  def commit_message
    "initial commit"
  end
  
  def run_segment
    self.run "touch tmp/.gitignore log/.gitignore vendor/.gitignore", :verbose => false
    self.run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}, :verbose => false
    self.copy_file("gitignore", '.gitignore')
    self.git :init
    self.run "git add -f tmp/.gitignore log/.gitignore vendor/.gitignore", :verbose => false
  end
  
end
