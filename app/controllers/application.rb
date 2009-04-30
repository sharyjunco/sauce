# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :perform_login, :perform_logout
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '9b7350892b0f6319118819f051335d0d'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  protected
  
  def perform_login
    if params.has_key?(:login) && params[:login] == ADMIN_SECRET
      session[:admin] = true
      logger.info 'Logged user in as admin.'
    end
  end
  
  def perform_logout
    if params.has_key?(:logout)
      session[:admin] = nil
      logger.info 'Logged user out as admin.'
    end
  end
end
