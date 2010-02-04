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
    if params[:board] && params[:board][:id]
      @board = Board.find_by_id(params[:board][:id])
    end
    @board_location = BoardLocation.new(params[:board_location])
        
    respond_to do |format|
      if (current_user.locations.any? { |existing_location| existing_location.matches?(@board_location)} || @board_location.save)
        flash[:notice] = 'Location was successfully created.'
        format.html { 
          if @board
            @board.location = @board_location
            @board.save
            redirect_to(edit_board_path(@board))
          else
            redirect_to(new_board_path)
          end
        }
      else
        format.html do 
          flash[:error] = 'Location was invalid. Please try again.'
          init_data_for_new_view
          render :action => "new" 
        end
      end
    end
  end
  

end

