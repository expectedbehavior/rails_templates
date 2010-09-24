class UserSessionsController < ApplicationController
  
  skip_before_filter :require_user
  skip_after_filter  :store_location, :only => [:destroy]

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
    current_user_session.andand.destroy
    flash[:notice] = "Logout successful!"
    redirect_to new_user_session_url
  end
  
end
