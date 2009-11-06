class Location < ActiveRecord::Base

  acts_as_geocodable
  # tells the db what column to put the object type into
  set_inheritance_column 'object_type'
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  validates_presence_of :locality, :region, :country 
  
  named_scope :ordered_by_desc_creation, :order => 'created_at desc'
  
  def matches?(other_location)
    street == other_location.street && locality == other_location.locality && region == other_location.region && postal_code == other_location.postal_code && country == other_location.country
  end
  
  def to_s
     "#{self.locality}, #{self.region} #{self.country}"
   end
end
