class BoardSearch < ActiveRecord::Base
  belongs_to :style
  belongs_to :location, :class_name => 'SearchLocation'
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  
  validates_presence_of :location, :message => "must be selected"
  
  def execute
    boards = Array.new
    BoardLocation.find(:all, :within => self.location.search_radius, :origin => self.location.to_s).each do |board_location|
      board_location.boards.active.each do |board|
        boards << board if (self.style == nil || board.style == self.style)
      end
    end
    return boards.uniq
  end
end
