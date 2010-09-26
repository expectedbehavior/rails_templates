class ForgotPasswordEmail < ActiveMailer::Base
  belongs_to :user
  
  def after_initialize
    self.subject      = "[<%= app_name %>] Reset Password"
    self.content_type = "text/html"
    self.sender       = EMAIL_FROM_ADDRESS
    self.recipients   = [self.user.email]
  end
  
  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end
