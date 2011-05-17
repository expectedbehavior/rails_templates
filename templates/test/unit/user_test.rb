require File.join(File.dirname(__FILE__), '..', 'test_helper')

class UserTest < ActiveSupport::TestCase
  test "test ignore_blank_passwords?" do 
    u = User.new
    u.password_validation_required = true
    assert_not u.ignore_blank_passwords?
  end
  
  test "test ignore_blank_passwords? without explicit set" do
    u = User.new
    assert u.ignore_blank_passwords?
  end
  
  test "name" do
    u = User.new(:first_name => "John", :last_name => "Smith")
    assert_equal "John Smith", u.name
  end
  
  test "deliver password" do
    u = Factory.create(:user)
    token = u.perishable_token
    assert_equal 0, ForgotPasswordEmail.count
    u.deliver_password_reset_instructions!
    assert_not_equal token, u.perishable_token
    assert_equal 1, ForgotPasswordEmail.count
  end
end
