class Reservation < ActiveRecord::Base
  belongs_to :board # this is belongs_to because the Reservations table has a board_id field.
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  has_many :reservation_dates, :class_name => 'UnavailableDate', :as => :parent
  
  accepts_nested_attributes_for :reservation_dates
  
  validates_length_of :reservation_dates, :minimum => 1, :message => 'must contain at least {count} date'
  validates_presence_of :board
  
  named_scope :for_user, lambda { |user| {:conditions => ['reservations.creator_id = ?', user.id]} }
  named_scope :created_since, lambda { |time| {:conditions => ['reservations.created_at >= ?', time]} }
  named_scope :inactive, :conditions => ["reservations.deleted_at IS NOT ?", nil]
  named_scope :deleted_since, lambda { |time| {:conditions => ["reservations.deleted_at > ?", time]} }
  named_scope :active, :conditions => ["reservations.deleted_at IS ?", nil]

  def destroy
    # see if someone above us tried to roll back.
    return false if callback(:before_destroy) == false
    mark_as_destroyed
    #allow the after_destroy
    callback(:after_destroy)
    self
  end



  protected

  def mark_as_destroyed
    self.update_attribute(:deleted_at, Time.now.utc)
  end
end

