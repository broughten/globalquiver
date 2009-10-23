class BoardsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]

  # GET /boards
  def index
    @board = Board.new(params[:board])

    if @board.location_id
        #if we're in here, that means someone searched by the dropdown list of locations
        @location = Location.find(@board.location_id)
    else
      if params[:location]
        @location = Location.new(params[:location])
        #we have to save this search location in order for geocoding to work on it
        @location.save
      else
        #if we didn't get a location on the search params we need to make one
        @location = Location.new
      end
    end

    # we pull up all the locations that the user has previously entered
    # because he might want to use one of these for the search he's about to perform
    @locations = Location.find_all_by_creator_id(current_user.id) unless current_user.nil?

    @boards = Board.search(@location)

    make_map_ready
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /boards/1
  def show
    @board = Board.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /boards/new
  def new

    # we pull up all the locations that the user has previously entered
    # because he might want to use one of these for the board he's about to enter
    @existing_locations = current_user.locations.ordered_by_desc_creation
    # create a new location here to hold the info if the user enters a new location
    @location = Location.new
    @board = @location.boards.build
    make_map_ready

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
  end

  # POST /boards
  # POST /boards.xml
  def create
    @board = Board.new(params[:board])
    
    if (!@board.has_location?)
      # let's create a new location because we don't have an existing one
      @location = Location.new(params[:location])
      if @location.save
        @board.location_id = @location.id
      end
    end
   
    respond_to do |format|
      if @board.save
        flash[:notice] = 'Board was successfully created.'
        format.html { redirect_to(overview_path) }
      else
        make_map_ready
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /boards/1
  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        flash[:notice] = 'Board was successfully updated.'
        format.html { redirect_to(overviews_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /boards/1
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to(overviews_path) }
    end
  end

private

  def make_map_ready
    # Create a new map object, also defining the div ("map")
    # where the map will be rendered in the view
    @map = GMap.new("map")
    # Use the larger pan/zoom control but disable the map type
    # selector
    @map.control_init(:large_map => true,:map_type => false)
    # Center the map on specific coordinates and focus in fairly
    # closely
    if (remote_location.nil? || remote_location.latitude.nil?)
      @map.center_zoom_init([25.165173,-158.203125], 1  )
    else
      @map.center_zoom_init([remote_location.latitude,remote_location.longitude], 11  )
    end
  end

end
