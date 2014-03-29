class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in? #this allows the views (in addition to the controllers) to be exposed to these methods below...makes these methods available to both controllers and views; without this helper_method, these methods below would ONLY be available to the contollers.

  def current_user
    #if there's an authenticated user, return the user obj
    #else return nil

    @current_user ||= User.find(session[:user_id]) if session[:user_id] #this will return nil if the session[:user_id] does not exist..which is what we'd want (the nil); otherwise, it will return the value of the found session id
               # '||=' is for memoization; it allows the user to hit the database only once rather than many times (when we call the 'current_user' method, which could be MANY times, like for example, when we want to display the up & down arrows that the logged-in user would have access to); ||= says that "If this instance variable exists already, then don't run this execution code--this 'current_user' method."
  end

  def logged_in?
    !!current_user # the !! turns this method into a boolean
                   # this allows us to run the login without running into nil exceptions
                   # that way we're always dealing with boolean (rather than 'nil') values
  end

  def require_user
    unless logged_in? #same as if !logged_in?
      access_denied
    end
  end


  def require_admin
    access_denied unless logged_in? and current_user.admin? # Definitely use 'unless logged_in?' here b/c if you don't, then you won't have current_user object; it would be nil and nil would not be able to run the .admin? method.
  end

  def access_denied
    flash[:error] = "You are not authorized to do that."
    redirect_to root_path # Must redirect_to in order to protect the actions that we're trying to protect (via the 'before_action' in the various controllers).  Otherwise, the request will continue to the actions against our wishes.
  end

end
