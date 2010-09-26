class PasswordResetsController < ApplicationController
  skip_before_filter :require_user
  before_filter      :load_user_using_perishable_token, :only => [ :edit, :update ]

  def new
    if current_user
      flash[:notice] = "You are already logged in, you can set your password here."
      redirect_to edit_user_path(current_user)
    end
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you."
      redirect_to root_path
    else
      flash[:error] = "No user was found with email address #{params[:email]}."
      render :action => :new
    end
  end

  def edit
  end

  def update
    @user.password_validation_required = true
    if @user.update_attributes(params[:user])

      flash[:success] = "Your password was successfully updated."
      redirect_to @user
    else
      render :action => :edit
    end
  end


  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "We're sorry, but we could not locate your account."
      redirect_to root_url
    end
  end
end
