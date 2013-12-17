class SessionsController < ApplicationController
  def new
    
  end

  def create
    # ex user.authenticate('password')
    # 1. get the user obj
    # 2. see if password matches
    # 3. if so, log in
    # 4. if not, error message
    # binding.pry
    user = User.find_by(username: params[:username]) # this actually could be a local variable since we don't have a model with it.

    if user && user.authenticate(params[:password]) # '&&' here means that if 'user' fails, then don't do the next thing (user.authenticate...); we're 'shore-circuiting' here
      session[:user_id] = user.id #never save object, b/c cookies are generated here; cookies grow as the user interacts & it could eventually lead to a cookie overflow error (sessions are only 4kb)
      flash[:notice] = "You've logged in"
      redirect_to root_path
    else
      flash[:error] = "There's something wrong with your username or password."
      redirect_to register_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've logged out"
    redirect_to root_path
  end
end