class DeployToHeroku < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Deploying to heroku...."
  end
  
  def ending_message
    "Deployed to heroku."
  end
  
  def commit_message
    "deployed to heroku"
  end
  
  def question
    "Would you like to deploy the app to heroku? [Yn]"
  end
  
  def run_segment
    self.copy_file File.join('lib', 'tasks', 'heroku_san_tasks.rake')
    heroku_name = self.app_name.downcase.gsub('_', '-')
    self.copy_template(:src => File.join('config', 'heroku.yml'), :assigns => { :app_name => heroku_name })
    self.run "rake all heroku:create heroku:rack_env"
    self.run "git push heroku master"
  end
  
end
