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
    self.git :rm => File.join('public', 'javascripts', 'controls.js')
    self.git :rm => File.join('public', 'javascripts', 'dragdrop.js')
    self.git :rm => File.join('public', 'javascripts', 'effects.js')
    self.git :rm => File.join('public', 'javascripts', 'prototype.js')
    
    self.plugin 'jrails', :git => 'git://github.com/aaronchi/jrails.git'
    
    system "./bin/compass init rails -r html5-boilerplate -u html5-boilerplate --force"
    self.gsub_file File.join('app', 'views', 'layouts', '_head.html.haml'), /  = csrf_meta_tag/, ""
    
    self.copy_file File.join('public', 'javascripts', 'lowpro.jquery.js')
    self.copy_file File.join('public', 'javascripts', 'behaviors.js')
    self.copy_file File.join('public', 'javascripts', 'jquery.livequery.js')
    self.copy_file File.join('public', 'javascripts', 'jquery-ui-1.8.5.custom.min.js')
    
    system "rm #{File.join('public', 'javascripts', 'rails.js')}"
    self.gsub_file(File.join('app', 'views', 'layouts', '_javascripts.html.haml'),
                   /javascript_include_tag 'rails', 'plugins', 'application'/,
                   "javascript_include_tag 'lowpro.jquery', 'jquery.livequery', 'plugins', 'application', 'behaviors'")
    
    self.copy_file File.join('app', 'views', 'home', 'index.html.haml')
    
    self.copy_file File.join('app', 'controllers', 'home_controller.rb')
    
    self.copy_file File.join('config', 'routes.rb')
    

  end
  
end
