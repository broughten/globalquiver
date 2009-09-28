class Location < ActiveRecord::Base

  acts_as_geocodable
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'

  has_many :boards
  
end
