class ReservationsController < ApplicationController

  before_filter :login_required
  # GET /boards/:id/reservations/new
  def new
    found_board = Board.find(params[:board_id])
    respond_to do |format|
      if (found_board.user_is_owner(current_user))
        flash[:error] = "You can't reserve your own board.  Please edit the board unavailable dates on the board details page."
        format.html { redirect_to(root_path) }
      else
        @reservation = Reservation.new
        @reservation.board = found_board
        format.html
      end
    end
  end
  
  # POST /boards/:id/reservations
  def create
    @reservation = Reservation.new(params[:reservation])
    @reservation.board = Board.find(params[:board_id])
    respond_to do |format|
      if @reservation.save
        flash[:notice] = "Reservation created.  Thank you."
        format.html { redirect_to(@reservation) }
      else
        flash[:error] = "Error saving reservation. Please try again."
        format.html { render :action => "new" }
      end
    end
  end
end