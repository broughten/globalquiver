class Reservation < ActiveRecord::Base
  belongs_to :board # this is belongs_to because the Reservations table has a board_id field.
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  has_many :reservation_dates, :class_name => 'UnavailableDate', :as => :parent
  
  accepts_nested_attributes_for :reservation_dates
  
  validates_length_of :reservation_dates, :minimum => 1, :message => 'must contain at least %d date'
  validates_presence_of :board
  
  named_scope :for_user, lambda { |user| {:conditions => ['reservations.creator_id = ?', user.id]} }
  named_scope :created_since, lambda { |time| {:conditions => ['reservations.created_at >= ?', time]} }
end
