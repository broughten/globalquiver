class BoardsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]

  # GET /boards
  # GET /boards.xml
  def index
    @boards = Board.search(params[:search])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @boards }
    end
  end

  # GET /boards/1
  # GET /boards/1.xml
  def show
    @board = Board.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @board }
    end
  end

  # GET /boards/new
  # GET /boards/new.xml
  def new

    # we pull up all the locations that the user has previously entered
    # because he might want to use one of these for the board he's about to enter
    @locations = Location.find_all_by_creator_id(current_user.id)
    
    @location = Location.new
    
    @board = @location.boards.build

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

      @location.region = remote_location.region
      @location.street = remote_location.street
      @location.postal_code = remote_location.postal_code
      @location.country = remote_location.country
      @location.locality = remote_location.city
    end


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @board }
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

    # if the location id is nill then we must be making a new location
    if @board.location_id.nil?
      @location = Location.new(params[:location])
      if @location.save
        @board.location_id = @location.id
      end
    end
   
    respond_to do |format|
      if @board.save
        flash[:notice] = 'Board was successfully created.'
        format.html { redirect_to(@board) }
        format.xml  { render :xml => @board, :status => :created, :location => @board }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.xml
  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        flash[:notice] = 'Board was successfully updated.'
        format.html { redirect_to(@board) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.xml
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to(boards_url) }
      format.xml  { head :ok }
    end
  end

  def remap
    @location = Location.new(params[:location])

    if (remote_location.latitude.nil?)
      @map.center_zoom_init([25.165173,-158.203125], 1  )
    else
      @map.center_zoom_init([remote_location.latitude,remote_location.longitude], 12  )
    end
    
  end

end
