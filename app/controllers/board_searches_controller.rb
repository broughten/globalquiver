class BoardSearchesController < ApplicationController
  def new
    @board_search = BoardSearch.new
    @search_locations = get_search_locations_for_view
  end
  
  def create
    @board_search = BoardSearch.new(params[:board_search])
    if @board_search.save
      redirect_to board_search_path(@board_search)
    else
      @search_locations = get_search_locations_for_view
      render :action => 'new'
    end
  end
  
  def show
    @search_locations = get_search_locations_for_view
    @board_search = BoardSearch.find(params[:id])
    @found_boards = @board_search.execute
    init_map_for_search_view
    @board_search = BoardSearch.new
  end
  
  private
  def get_search_locations_for_view
    SearchLocation.all
  end

  def init_map_for_search_view
    search_location = @board_search.location
    @map = GMap.new("map")
    # Use the larger pan/zoom control but disable the map type
    # selector
    @map.control_init(:large_map => true,:map_type => false)

    #center map around search location and zoom in according to the search radius
    zoom_level = (search_location.search_radius < 100)?8:10
    @map.center_zoom_init([search_location.geocode.latitude,search_location.geocode.longitude], zoom_level)


    #make a marker for each distinct location
    surfer_locations_to_mark = []
    shop_locations_to_mark = []
    @found_boards.each do |board|
      if board.creator.is_a?(Surfer)
        surfer_locations_to_mark << board.location
      else
        shop_locations_to_mark << board.location
      end
    end

    #Make a map icon for surfers
    @map.icon_global_init(GIcon.new(:image => "/images/surf.png",
                                    :icon_size => GSize.new(48, 48),
                                    :icon_anchor => GPoint.new(48, 48),
                                    :info_window_anchor => GPoint.new(0, 5)), 'surfer_icon')
    surfer_icon = Variable.new('surfer_icon')

    #Make a map icon for shops
    @map.icon_global_init(GIcon.new(:image => "/images/shop.png",
                                    :icon_size => GSize.new(48, 48),
                                    :icon_anchor => GPoint.new(48, 48),
                                    :info_window_anchor => GPoint.new(0, 5)), 'shop_icon')
    shop_icon = Variable.new('shop_icon')

    #put surfer icons on the map for each location along with an info window that pops up when you click it
    surfer_locations_to_mark.uniq.each do |location|
      @map.overlay_init(GMarker.new([location.geocode.latitude,location.geocode.longitude], 
                                    :icon => surfer_icon,
                                    :info_window => "
                                      <div style='width:200px;height:60px'>
                                        <a style='font-size:14px' href='#{user_path(location.creator_id)}'>#{location.creator.full_name}</a>
                                        <p style='font-size:12px'>Surfer locations are where you go to do the board exchange. Not necessarily their real addresses.</p>
                                      </div>",
                                    :title => "surfer"
                                  ))
    end
    
    #put shop icons on the map for each location along with an info window that pops up when you click it
    shop_locations_to_mark.uniq.each do |location|
      @map.overlay_init(GMarker.new([location.geocode.latitude,location.geocode.longitude], 
                                    :icon => shop_icon,
                                    :info_window => "
                                      <div style='width:200px;height:60px'>
                                        <a style='font-size:14px' href='#{user_path(location.creator_id)}'>#{location.creator.full_name}</a>
                                        <p style='font-size:13px'>#{location.street}</p>
                                        <p style='font-size:13px'>#{location.locality}, #{location.region}, #{location.postal_code}</p>
                                      </div>",
                                    :title => "surf shop"
                                    ))
    end

  end

end
