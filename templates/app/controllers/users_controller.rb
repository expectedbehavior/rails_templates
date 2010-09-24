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
  
  def show
    if params[:id] != current_user.id.to_s
      redirect_to user_path(current_user)
    else
      @user = current_user
    end
  end

  def edit
    if params[:id] != current_user.id.to_s
      redirect_to edit_user_path(current_user)
    else
      @user = current_user
    end
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User details were successfully updated.'
      redirect_to(@user)
    else
      render :action => "edit"
    end
  end
  
end
