# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Don't log passwords!
  filter_parameter_logging :plain_password

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_clubcar_session_id'

  before_filter :authorize
  
  helper :builder

  private

  def authorize 
    # Gah! This datatype is useless!
    # unless !session.has_key?(:user) || ...
    unless !session[:user].nil? && session[:user].valid?
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to(:controller => "users", :action => "login")
    else
      # Pull it from the DB again. This guarantees the session object is
      # up-to-date at the (minute) expense of some performance
      session[:user] = User.find(session[:user].id)
    end
  end

  def admin_access
    if ( params.has_key?(:user_id) )
      id  = params[:user_id]
    else
      id = params[:id]
    end

    return if id.blank? || session[:user].nil? || id.to_i == session[:user].id

    unless (session[:user].is_admin?) 
      flash[:notice] = "You are not an administrator!"
      redirect_to(:controller => "users")
    end
    
  end
end
