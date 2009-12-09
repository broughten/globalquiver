class Reservation < ActiveRecord::Base
  belongs_to :board # this is belongs_to because the Reservations table has a board_id field.
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  has_many :dates, :class_name => 'UnavailableDate'
  
  validates_length_of :dates, :minimum => 1, :message => 'must contain at least %d date'
end
