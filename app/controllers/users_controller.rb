class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update] #if a user tries to edit another user's profile, he'll be redirected to the root directory and be given an error message
              # :require_same_user is a method defined at the bottom of this 'users_controller.rb' file.
  def show
    #use set_user action below
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id # We do this in order to allow the newly-created user to automatically log in when he/she registers.
      flash[:notice] = "You are registered"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    #use set_user action below
  end

  def update
    #use set_user action below
    if @user.update(user_params)
      flash[:notice] = "Your info is updated."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :phone, :time_zone)
  end

  def set_user
    @user = User.find_by slug: params[:id]
  end

  def require_same_user # Thus with this, you may only edit/update your OWN profile.
    if current_user != @user
      flash[:error] = "You're not allowed to do that since you are not that user/creator."
      redirect_to root_path
    end
  end
end