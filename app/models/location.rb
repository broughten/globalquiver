class Location < ActiveRecord::Base

  acts_as_geocodable

  has_many :boards
  
end
