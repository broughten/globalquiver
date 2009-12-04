class BoardLocationsController < ApplicationController
  before_filter :login_required
  
  # GET /locations/new
  def new
    @board_location = BoardLocation.new    
    respond_to do |format|
      format.html {init_data_for_new_view}
    end
  end

  # POST /locations
  def create
    @board_location = BoardLocation.new(params[:board_location])
        
    respond_to do |format|
      if (current_user.locations.any? { |existing_location| existing_location.matches?(@board_location)} || @board_location.save)
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to new_board_path }
      else
        format.html do 
          flash[:error] = 'Location was invalid. Please try again.'
          init_data_for_new_view
          render :action => "new" 
        end
      end
    end

  end
  
  private
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

