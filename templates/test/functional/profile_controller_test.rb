require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ProfileControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @u = Factory.create(:user)
    UserSession.create(@u)
  end
  
  test "user gets set" do
    get :show, :id => @u.id
    assert_response :success
    assert_not_nil assigns(:user)
    
    get :edit, :id => @u.id
    assert_response :success
    assert_not_nil assigns(:user)
    
    put :update, :id => @u.id, :user => {}
    assert_response :redirect
    assert_not_nil assigns(:user)
  end
  
  test "update user" do
    put :update, :id => @u.id, :user => { :first_name => "Testery"}
    assert_response :redirect
    assert_equal "Your profile was successfully updated.", flash[:notice]
    assert_redirected_to profile_path
  end

  test "can't update user without first/last name" do 
    @u.first_name = nil
    put :update, :id => @u.id, :user => {:first_name => nil }
    assert_response :success
    assert_template :edit
    
    put :update, :id => @u.id, :user => {:last_name => nil }
    assert_response :success
    assert_template :edit
  end
end
