class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in? #this allows the views (in addition to the controllers) to be exposed to these methods below...

  def current_user
    #if there's an authenticated user, return the user obj
    #else return nil

    User.find(session[:user_id]) if session[:user_id] #this will return nil if the session[:user_id] does not exist..which is what we'd want (the nil)
  end

  def logged_in?
    !!current_user # the !! turns this method into a boolean
                   # this allows us to run the login without running into nil exceptions
                   # that way we're always dealing with boolean (rather than 'nil') values
  end

end
