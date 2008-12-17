# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c140536dbebdb5928dda4cfd14922cd3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

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
    end
    @user = session[:user]
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
