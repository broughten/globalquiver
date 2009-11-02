class LocationsController < ApplicationController
  before_filter :login_required
  
  # GET /locations/new
  def new
    @location = Location.new    
    respond_to do |format|
      format.html {init_data_for_new_view}
    end
  end

  # POST /locations
  def create
    @location = Location.new(params[:location])
        
    respond_to do |format|
      if (current_user.locations.any? { |existing_location| existing_location.matches?(@location)} || @location.save)
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to new_board_path }
      else
        format.html do 
          init_data_for_new_view
          render :action => "new" 
        end
      end
    end

  end
  
  private
  def init_data_for_new_view
    @existing_locations = current_user.locations
    @map = GMap.new("map")
    # Use the larger pan/zoom control but disable the map type
    # selector
    @map.control_init(:large_map => true,:map_type => false)
    @map.center_zoom_init([25.165173,-158.203125],1)
  end
end
