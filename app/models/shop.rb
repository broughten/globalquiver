class Shop < User
  
  validates_presence_of :name

  attr_accessible :name

  # This will give us a common way to display someone's name
  # depending on what type of user they are.
  def display_name
    read_attribute(:name)
  end
  
  def full_name
    read_attribute(:name)
  end

  def is_rental_shop?
    true
  end
  
  def self.with_uninvoiced_reservations
    shops = []
    
    Shop.all.each do |shop|
      if shop.reservations_for_owned_boards.uninvoiced.count > 0
        shops << shop 
      end
    end
    
    shops
  end

end