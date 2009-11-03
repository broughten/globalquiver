class BoardLocation < Location

  validates_presence_of :street, :postal_code
  has_many :boards
  
end