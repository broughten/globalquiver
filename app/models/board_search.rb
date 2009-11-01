class BoardSearch < ActiveRecord::Base
  belongs_to :style
  belongs_to :geocode
  
  validates_presence_of :geocode, :message => "must be selected"
  
  def execute
    search = Board.location_geocoding_geocode_id_equals(geocode.id)
    #further refine the search for board.style
    search = search.style_id_equals(style.id) if style != nil
    search.all
  end
end
