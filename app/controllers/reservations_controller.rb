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
    init_map_for_show_view

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # DELETE /reservations/1
  def destroy
    @reservation = Reservation.find(params[:id])
    respond_to do |format|
      if (@reservation.creator != current_user)
          flash[:error] = "You can't cancel someone else's reservation"
          format.html { redirect_to :back }
      elsif @reservation.destroy
        flash[:notice] = 'Reservation was successfully canceled.'
        UserMailer.deliver_reservation_cancelation_details(@reservation)
        format.html { redirect_to(root_path) }
        format.js
      else
        flash[:error] = @reservation.errors.full_messages.first
        format.html { redirect_to(:back) }
        format.js
      end
    end
  end

  def init_map_for_show_view
    place = @reservation.board.location
    @map = GMap.new("map")
    # Use the larger pan/zoom control but disable the map type
    # selector
    @map.control_init(:large_map => true,:map_type => false)

    #center map around search location and zoom in according to the search radius
    zoom_level = 12
    @map.center_zoom_init([place.geocode.latitude,place.geocode.longitude], zoom_level)


    #Make a map icon for surfers
    @map.icon_global_init(GIcon.new(:image => "/images/surf.png",
                                    :icon_size => GSize.new(48, 48),
                                    :icon_anchor => GPoint.new(48, 48),
                                    :info_window_anchor => GPoint.new(0, 5)), 'surfer_icon')
    surfer_icon = Variable.new('surfer_icon')

    #put surfer icon on the map
    @map.overlay_init(GMarker.new([place.geocode.latitude,place.geocode.longitude],
                                    :icon => surfer_icon,
                                    :info_window => "
                                      <div>
                                        <a style='font-size:14px' href='#{user_path(@reservation.board.creator_id)}'>#{@reservation.board.creator.full_name}</a>
                                        <p style='font-size:13px'>#{place.street}</p>
                                        <p style='font-size:13px'>#{place.locality}, #{place.region}, #{place.postal_code}</p>
                                      </div>",
                                    :title => "board location"
                                    ))


  end


end