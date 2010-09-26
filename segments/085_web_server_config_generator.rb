class WebServerConfigGenerator < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Running web server config generator..."
  end
  
  def ending_message
    "Web server config generator run"
  end
  
  def commit_message
    "webconfig.yml"
  end
  
  def question
    "Would you like to run the web server config generator? [Yn]"
  end
  
  def run_segment
    system "web_server_setup ."
  end
  
end
