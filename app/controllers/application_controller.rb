# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  user_stamp UserSearch, SearchLocation, UserLocation, BoardLocation, Board, Location, UnavailableDate, BoardSearch, Reservation, GenericBoard, SpecificBoard

  include AuthenticatedSystem
  helper :all # include all helpers, all the time

  helper_method :admin?

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
      redirect_to root_path
    end
  end

  protected

  def authorize
    unless admin?
      flash[:error] = "Unauthorized access"
      redirect_to root_path
      false
    end
  end

  def admin?
    if current_user
      current_user.role?(:admin)
    else
      false
    end
  end

  protected
  def init_data_for_new_view
    @existing_locations = current_user.board_locations
    @map = GMap.new("map")
    # Use the larger pan/zoom control but disable the map type
    # selector
    @map.control_init(:large_map => true,:map_type => false)

    if !@existing_locations.blank?
      @map.center_zoom_init([@existing_locations.first.geocode.latitude.to_f, @existing_locations.first.geocode.longitude.to_f], 11)
    else
      if (remote_location.nil? || remote_location.latitude.nil?)
        @map.center_zoom_init([33.01802,-117.27828], 8 )
      else
        @map.center_zoom_init([remote_location.latitude,remote_location.longitude], 11 )
      end
    end
  end

end
