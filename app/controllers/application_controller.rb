class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in? #this allows the views (in addition to the controllers) to be exposed to these methods below...

  def current_user
    #if there's an authenticated user, return the user obj
    #else return nil

    @current_user ||= User.find(session[:user_id]) if session[:user_id] #this will return nil if the session[:user_id] does not exist..which is what we'd want (the nil); otherwise, it will return the value of the found session id
               # '||=' is for memoization; it allows the user to hit the database only once rather than many times (when we call the 'current_user' method, which could be MANY times)
  end

  def logged_in?
    !!current_user # the !! turns this method into a boolean
                   # this allows us to run the login without running into nil exceptions
                   # that way we're always dealing with boolean (rather than 'nil') values
  end

  def require_user
    unless logged_in? #same as if !logged_in?
      flash[:error] = "Must be logged in to do that."
      redirect_to root_path
    end
  end

end
