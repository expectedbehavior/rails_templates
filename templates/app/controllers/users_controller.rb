class UsersController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]

  def new
    @user = User.new(params[:user])
  end
  
  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = 'Thanks for signing up'
      redirect_to(@user)
    else
      render :action => "new"
    end
  end
end
