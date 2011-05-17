require File.join(File.dirname(__FILE__), '..', 'test_helper')

class UsersControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
  end
  
  test "should get new for user" do
    get :new
    assert_response :success
  end

  test "handle bad create inputs" do
    post :create, :user => {}
    assert_template "new"
    assert_nil flash[:notice]
  end
  
  test "handle good create inputs" do
    post :create, :user => { :email => "shenanana@example.com", :first_name => "She-na", :last_name => "Na-Na", :password => "secret", :password_confirmation => "secret"}
    assert_response :redirect
    assert_equal "Thanks for signing up", flash[:notice]
    assert_redirected_to profile_path
  end
end
