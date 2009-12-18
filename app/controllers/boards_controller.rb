class BoardsController < ApplicationController

  before_filter :login_required, :except => [:index, :show]

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
      redirect_to new_board_location_path
    else
      # we pull up all the locations that the user has previously entered
      # because he might want to use one of these for the board he's about to enter
      @existing_locations = current_user.board_locations.ordered_by_desc_creation
      @board = Board.new
      # allow for pictures on each board
      Board::MAX_IMAGES.times {@board.images.build}
      respond_to do |format|
        format.html # new.html.erb
      end
    end
    
  end


  # POST /boards
  # POST /boards.xml
  def create
    @board = Board.new(params[:board])

    respond_to do |format|
      if @board.save
        flash[:notice] = 'Board was successfully created.'
        format.html { redirect_to(root_path) }
      else
        @existing_locations = current_user.board_locations.ordered_by_desc_creation
        (Board::MAX_IMAGES - @board.images.length).times {@board.images.build}
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
        format.html { redirect_to(@board) }
        format.js
      else
        format.html { render :action => "show" }
        format.js
      end
    end
  end

  # DELETE /boards/1
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
    end
  end

end
