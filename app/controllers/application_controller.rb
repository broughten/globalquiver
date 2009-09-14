# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8e3b3414d0c61fed1b3b7d14148885a2'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to(return_to)
    else
      redirect_to :controller=>'user', :action=>'welcome'
    end
  end


  #TODO get an owner on the boards
  #TODO get an owner on the locations
  #TODO Make the map only load if there's no location or if the user requests it
  #TODO make some board fields required and others optional
  #TODO make the board type something that comes from an ever growing dropdown
  #TODO provide a dropdown of previous locations for subsequent board additions.
  

end
