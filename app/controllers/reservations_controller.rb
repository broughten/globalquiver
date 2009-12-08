class ReservationsController < ApplicationController

  # GET /boards/new
  def new
    @board = Board.find(params[:id])
    @reservation = Reservation.new

    respond_to do |format|
      format.html # show.html.erb
    end
  end

end
