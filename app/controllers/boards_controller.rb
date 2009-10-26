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
    if current_user.locations.empty?
      # we need a location before we can create a board so
      # go out and get one.
      redirect_to new_location_path
    else
      # we pull up all the locations that the user has previously entered
      # because he might want to use one of these for the board he's about to enter
      @existing_locations = current_user.locations.ordered_by_desc_creation
      @board = Board.new

      # allow for 4 pictures on each board
      4.times {@board.images.build}
      respond_to do |format|
        format.html # new.html.erb
      end
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

    respond_to do |format|
      if @board.save
        flash[:notice] = 'Board was successfully created.'
        format.html { redirect_to(overview_path) }
      else
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
        format.html { redirect_to(overview_path) }
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
      format.html { redirect_to(overview_path) }
    end
  end
end
