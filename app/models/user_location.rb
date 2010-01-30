class UserLocation < Location
  has_many :shops, :foreign_key => "location_id"
  has_many :surfers, :foreign_key => "location_id"

end