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
  
  def run
    self.runner.run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
    self.runner.run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
    self.copy_file("gitignore", '.gitignore')
    self.runner.git :init
  end
  
end
