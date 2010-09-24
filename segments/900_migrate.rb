class MigrateDatabase < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Migrating the database..."
  end
  
  def ending_message
    "Database migrated"
  end
  
  def commit_message
    "database migrated"
  end
  
  def question
    "Would you like to migrate the database? [Yn]"
  end
  
  def run_segment
    self.run "rake db:migrate"
    self.run "rake db:test:prepare"
  end
  
end
