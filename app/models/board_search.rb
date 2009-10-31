class BoardSearch < ActiveRecord::Base
  belongs_to :style
  belongs_to :geocode
  
  validates_presence_of :geocode, :message => "must be selected"
end
