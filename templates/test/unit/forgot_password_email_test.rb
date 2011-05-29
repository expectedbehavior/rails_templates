require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ForgotPasswordEmailTest < ActiveSupport::TestCase
  def setup
    @u = Factory.create(:user)
  end
  
  test "initialization is correct" do
    fpe = ForgotPasswordEmail.new(:user => @u)
    assert_equal "[<%= app_name %>] Reset Password", fpe.subject
    assert_equal "text/html", fpe.content_type
    assert_equal "support@expectedbehavior.com", fpe.sender.email_address
    assert_equal 1, fpe.recipients.size
    assert_equal @u.email, fpe.recipients[0].email_address
  end
  
  test "email contents updated after send" do
    fpe = ForgotPasswordEmail.create(:user => @u)
    assert_nil fpe.rendered_email_contents
    fpe.send!
    
    expected_response = <<-END
<h1>Password Reset Instructions</h1>
<p>
A request to reset your password has been made. If you did not make
this request, simply ignore this email. If you did make this
request, please follow the link below.
</p>
<a href=\"http://<%= fqdn %>/password_resets/#{@u.perishable_token}/edit\">Reset Password!</a>
END
    
    assert_equal expected_response, fpe.rendered_email_contents
  end
end
