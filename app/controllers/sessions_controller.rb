class SessionsController < ApplicationController
  def new
    
  end

  def create
    # ex user.authenticate('password')
    # 1. get the user obj
    # 2. see if password matches
    # 3. if so, log in
    # 4. if not, error message
    user = User.find_by(username: params[:username]) # this actually could be a local variable since we don't have a model with it.
  # user = User.where(username: params[:username]).first is an alternative way to get a 'user' object
    if user && user.authenticate(params[:password]) # '&&' here means that if 'user' fails, then don't do the next thing (user.authenticate...); we're 'shore-circuiting' here
      if user.two_factor_auth? # <-- method in 'user.rb' which checks to see whether the user has a phone number
        session[:two_factor] = true # Setting this 'true' value to the key ':two_factor' prevents someone from typing '/pin' into the URL and trying to punch in 6-digit numbers; this says that a user must be in the session in order to access that page('/pin').
        # generate a pin
        user.generate_pin! # <-- method in 'user.rb' that creates a random 6-digit pin
        # send pin to twilio, sms to user's phone
        user.send_pin_to_twilio # method in 'user.rb'
        # show pin form; whenever we have to 'show a form' that means we need a new route (in this case, to display the form and to handle the post of that form, as well); we actually need two new routes: one for the 'get' and one for the 'post'.
        redirect_to pin_path #this 'pin_path' helper method was invoked in 'routes.rb' [from.. get '/pin']; this goes to the 'views/sessions/pin.html.erb' template
      else
        login_user!(user) # private method below..
      end
    else
      flash[:error] = "There's something wrong with your username or password."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've logged out"
    redirect_to root_path
  end

  def pin #in 'routes.rb', this method/action must be specifically delineated for a 'post' request, but it is not necessary (just assumed to be there) by the 'get' request (the 'get' request simply renders the 'pin.html.erb' template); since we do have a 'post' request, we need this method here.
    access_denied if session[:two_factor].nil? # 'access_denied' method is from 'application_controller.rb'

    if request.post? #if the request is not a 'post' (a 'get'), then it just renders the template automatically, but if it is a 'post' request, it will execute this code.
      user = User.find_by pin: params[:pin] # params[:pin] is the value passed in by the form.
      if user
        session[:two_factor] = nil #this means that the user has successfully logged in & it no longer needs to equal 'true' (see 'create' method above..)
        # remove pin because, we want to reduce the chance for future collisions; it should be unique for that one session
        user.remove_pin!
        # normal login success
        login_user!(user) # private method below..
      else
        flash[:error] = "Something is wrong with your pin number" # We're doing the flash[:error] here b/c the 'views/sessions/pin.html.erb' template is a non-model-backed form.
        redirect_to pin_path
      end
    end    
  end

  private

  def login_user!(user)
    session[:user_id] = user.id #never save object, b/c cookies are generated here; cookies grow as the user interacts & it could eventually lead to a cookie overflow error (sessions are only 4kb)
    flash[:notice] = "You've logged in"
    redirect_to root_path
  end

end