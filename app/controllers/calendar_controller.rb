class CalendarController < ApplicationController

  @type = nil

  def shop_calendar
    @type = "shop"
    index
  end

  def trip_calendar
    @type = "trip"
    index
  end

  def index
    @month = params[:month].to_i
    @year = params[:year].to_i

    @shown_month = Date.civil(@year, @month)

    start_d, end_d = Reservation.get_start_and_end_dates(@shown_month)
    if(@type == "trip")
      @reservations = Reservation.for_user(current_user).for_date_range(start_d, end_d)
    else
      @reservations = Reservation.for_boards_of_user(current_user).for_date_range(start_d, end_d)
    end
    @reservation_strips = Reservation.create_reservation_strips(start_d, end_d, @reservations)
    
		respond_to do |format|
      format.html # index.html.erb
    end
  end
  
end