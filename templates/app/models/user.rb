class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  attr_accessor :password_validation_required
  
  def ignore_blank_passwords?
    return false if self.password_validation_required
    self.class.ignore_blank_passwords == true
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    ForgotPasswordEmail.create(:user_id => self.id).send!
  end

end
