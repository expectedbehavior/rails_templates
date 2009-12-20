generate(:session, "user_session")
generate(:controller, "user_sessions")

gsub_file "app/models/user.rb", /^(class User.*)/, "\\1\n  acts_as_authentic"

gsub_file "app/controllers/application_controller.rb", /end\s*\Z/m, <<-END

  private
 
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
 
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
 
end
END

file "app/controllers/user_sessions_controller.rb", <<-END
class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to root_path
    else
      flash[:error] = "Login failed."
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to new_user_session_url
  end
  
end
END

file "app/views/user_sessions/new.haml", <<-END
%h2 Login
- form_for @user_session do |f|
  = f.error_messages
  %p
    = f.label :email
    %br
    = f.text_field :email
  %p
    = f.label :password
    %br
    = f.password_field :password
  %p
    = f.submit "Submit"
END

git :add => '.'
git :commit => "-m 'authentication'"
