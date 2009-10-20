class Location < ActiveRecord::Base

  acts_as_geocodable
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  validates_presence_of :locality, :country
  has_many :boards
  
  named_scope :ordered_by_desc_creation, :order => 'created_at desc'
end
