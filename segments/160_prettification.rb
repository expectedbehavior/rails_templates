# based on http://www.transdmin.perspectived.com/
class PrettifyRails < TemplateSegment
  
  def required?
    false
  end
  
  def starting_message
    "Prettifying to look somewhat like transadmin template (http://www.transdmin.perspectived.com/)"
  end
  
  def ending_message
    "Wham. Bam. Prettified, Ma'am"
  end
  
  def commit_message
    "prettier than your scaffolding"
  end
  
  def question
    "Would you like to have a pretty scaffold? [Yn]"
  end
  
  def run_segment
    self.copy_file File.join('app', 'stylesheets', 'partials', '_page.scss')
    self.copy_file File.join('app', 'stylesheets', 'partials', '_scaffold.sass')
    self.copy_file File.join('app', 'views', 'layouts', 'application.html.haml')
  end
end
