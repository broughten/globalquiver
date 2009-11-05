class SearchLocation < Location
  
  validates_presence_of :search_radius
  
  def to_s
    "#{self.locality}, #{self.region} #{self.country}"
  end
  
end