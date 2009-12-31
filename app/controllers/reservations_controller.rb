class ReservationsController < ApplicationController

  before_filter :login_required
  # GET /boards/:id/reservations/new
  def new
    found_board = Board.find(params[:board_id])
    respond_to do |format|
      if (found_board.user_is_owner(current_user))
        flash[:error] = "You can't reserve your own board.  Please edit the board unavailable dates on the board details page."
        format.html { redirect_to :back }
      elsif (!found_board.active?)
        flash[:error] = "This board got snaked while you were reserving it. Sorry. Try another one."
        format.html { redirect_to :back }
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
        UserMailer.deliver_board_renter_reservation_details(@reservation)
        format.html { redirect_to(reservation_path(@reservation)) }
      else
        flash[:error] = "Error saving reservation. Please try again."
        format.html { render :action => "new" }
      end
    end
  end
  
  # GET /reservations/1
  def show
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # DELETE /reservations/1
  def destroy
    @reservation = Reservation.find(params[:id])
    respond_to do |format|
      if @reservation.destroy
        flash[:notice] = 'Reservation was successfully canceled.'
        format.html { redirect_to(:back) }
        format.js
      else
        format.html { redirect_to(:back) }
        format.js
      end
    end
  end
end