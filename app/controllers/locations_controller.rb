class LocationsController < ApplicationController
  before_filter :login_required
  
  # GET /locations/new
  def new
    @new_location = Location.new
    @existing_locations = current_user.locations
    @map = GMap.new("map")
    
    # Use the larger pan/zoom control but disable the map type
    # selector
    @map.control_init(:large_map => true,:map_type => false)
    @map.center_zoom_init([25.165173,-158.203125],1)
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /locations
  def create
    @location = Location.new(params[:location])
        
    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to new_board_path }
      else
        format.html { render :action => "new" }
      end
    end

  end
end
