class BoardSearch < ActiveRecord::Base
  belongs_to :style
  belongs_to :location, :class_name => 'SearchLocation'
  
  validates_presence_of :location, :message => "must be selected"
  
  def execute
    board_locations = BoardLocation.find(:all, :within => self.location.search_radius, :origin => self.location.to_s)
    Board.all
  end
end
