class BoardLocation < Location

  validates_presence_of :street, :postal_code
  #We have to tell rails the foreign because it will try to link on board_location_id
  has_many :boards, :foreign_key => "location_id" 
  
end