class SessionKey < TemplateSegment
  
  def required?
    true
  end
  
  def starting_message
    "Setting session key"
  end
  
  def ending_message
    "Session key set"
  end
  
  def commit_message
    "session key"
  end
  
  def secret
    ActiveSupport::SecureRandom.hex(64)
  end
  
  def session_line
    "config.action_controller.session = { :session_key => '_#{self.app_name.down_under}_session', :secret => '#{self.secret}'}}\n"
  end
  
  def run_segment
    self.environment(self.session_line)
  end
  
end
