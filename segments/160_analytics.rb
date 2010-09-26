class AddGoogleAnalytics < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Adding google analytics..."
  end
  
  def ending_message
    "Added google analytics."
  end
  
  def commit_message
    "google analytics"
  end
  
  def question
    "Would you like to add google analytics? [Yn]"
  end
  
  def run_segment
    ga_key = HighLine.ask("google analytics key for application: ")
    append_string(File.join('app', 'views', 'layouts', 'application.html.haml'),
                  render_template(:src => File.join('app', 'views', 'layouts', 'application.html.haml', 'analytics.html.haml'),
                                  :assigns => { :ga_key => ga_key }))
  end
  
end
