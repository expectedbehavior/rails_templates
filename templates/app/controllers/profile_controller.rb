class ProfileController < ApplicationController
  before_filter :get_user
  
  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Your profile was successfully updated.'
      redirect_to(:profile)
    else
      render :action => "edit"
    end
  end

  private

  def get_user
    @user = current_user
  end
end
