class Location < ActiveRecord::Base

  acts_as_geocodable
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  validates_presence_of :locality, :postal_code, :country
  has_many :boards
end
