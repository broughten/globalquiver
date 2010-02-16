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
      @board = SpecificBoard.new
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
    @board = SpecificBoard.new(params[:board])

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

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])

    # we pull up all the locations that the user has previously entered
    # because he might want to use one of these for the board he's about to enter
    @existing_locations = current_user.board_locations.ordered_by_desc_creation
    (0..Board::MAX_IMAGES).each do |index|

      if @board.images[index].nil?
        @board.images.build

      end
    end
    
  end

  # PUT /boards/1
  def update
    #we need to bail out if someone tries to upload a non jpg or png image
    
    @board = Board.find(params[:id])

    if params[:board] && params[:board][:inactive]
      attempting_to_deactivate = true
    end

    respond_to do |format|
      if @board.creator != current_user
        flash[:error] = "Only the board owner can activate and deactivate boards."
        format.html { redirect_to(:back) }
        format.js
      elsif attempting_to_deactivate && @board.has_future_reservations
        flash[:error] = "This board cant be deactivated because it has upcoming reservations. Please contact the reservation holder(s) if this board is truly no longer available."
        format.html { redirect_to(:back) }
        format.js
      elsif @board.update_attributes(params[:board])
        flash[:notice] = 'Board was successfully updated.'
        format.html { redirect_to(board_path(@board)) }
        format.js
      else
        format.html {
          @existing_locations = current_user.board_locations.ordered_by_desc_creation

          render :edit 
        }
        format.js
      end
    end
  end

  def new_comment
    @board = Board.find(params[:id])
    @comment = Comment.build_from(@board, current_user.id, params[:comment][:body] )

    respond_to do |format|
      if @comment.save
        if !@board.user_is_owner(current_user)
          UserMailer.deliver_comment_notification(current_user, @board.creator, @comment)
        end
        format.js
      else
        format.js {
          render :inline => "alert('Ooops! Something went wrong. Please refresh this page and try again.');"
        }
      end
    end
  end

  def new_location_for_board
    @board = Board.find_by_id(params[:id])
    @board_location = BoardLocation.new
    respond_to do |format|
      format.html {init_data_for_new_view}
    end
  end


end
