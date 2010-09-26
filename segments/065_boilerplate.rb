class AddBoilerplate < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Adding boilerplate..."
  end
  
  def ending_message
    "Boilerplate added"
  end
  
  def commit_message
    "boilerplate"
  end
  
  def run_segment
    self.copy_file File.join('public', 'robots.txt')
    self.copy_file File.join('public', 'crossdomain.xml')
    
    self.copy_file File.join('public', 'stylesheets', 'boilerplate.css')
    self.copy_file File.join('public', 'stylesheets', 'handheld.css')
    
    self.copy_file File.join('public', 'javascripts', 'modernizr-1.5.min.js')
    self.copy_file File.join('public', 'javascripts', 'jquery-1.4.2.min.js')
    self.copy_file File.join('public', 'javascripts', 'dd_belatedpng.js')
    self.copy_file File.join('public', 'javascripts', 'lowpro.jquery.js')
    self.copy_file File.join('public', 'javascripts', 'behaviors.js')
    self.copy_file File.join('public', 'javascripts', 'jquery.livequery.js')
    self.copy_file File.join('public', 'javascripts', 'jquery-ui-1.8.5.custom.min.js')
    
    self.copy_file File.join('app', 'views', 'home', 'index.html.haml')
    self.copy_file(File.join('app', 'views', 'layouts', 'application.html.haml', 'application.html.haml'), 
                   File.join('app', 'views', 'layouts', 'application.html.haml'))
    
    self.copy_file File.join('app', 'controllers', 'home_controller.rb')
    
    self.copy_file File.join('config', 'routes.rb')
    
    self.git :rm => File.join('public', 'javascripts', 'controls.js')
    self.git :rm => File.join('public', 'javascripts', 'dragdrop.js')
    self.git :rm => File.join('public', 'javascripts', 'effects.js')
    self.git :rm => File.join('public', 'javascripts', 'prototype.js')
  end
  
end
