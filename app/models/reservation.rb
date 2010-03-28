class Reservation < ActiveRecord::Base
  has_reservation_calendar
  belongs_to :board # this is belongs_to because the Reservations table has a board_id field.
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'
  has_many :reserved_dates, :class_name => 'UnavailableDate', :as => :parent, :order => 'date'
  
  accepts_nested_attributes_for :reserved_dates
  
  validates_length_of :reserved_dates, :minimum => 1, :message => 'must contain at least {count} date'
  validates_presence_of :board
  validate :board_must_be_active

  named_scope :for_boards_of_user, lambda { |user| {:joins => :board, :conditions => ['boards.creator_id = ?', user.id]} }
  named_scope :for_user, lambda { |user| {:conditions => ['reservations.creator_id = ?', user.id]} }
  named_scope :created_since, lambda { |time| {:conditions => ['reservations.created_at >= ?', time]} }
  named_scope :inactive, :conditions => ["reservations.deleted_at IS NOT ?", nil]
  named_scope :deleted_since, lambda { |time| {:conditions => ['reservations.deleted_at >= ?', time]} }
  named_scope :active, :conditions => ["reservations.deleted_at IS ?", nil]
  named_scope :with_dates_after, 
      lambda { |time| {:select => "DISTINCT reservations.*",:joins=>:reserved_dates, :conditions => ['date > ?', time]} }
       
  def before_destroy
    if (too_near_to_delete)
      errors.add_to_base "Cannot delete reservation less than 1 day away"
      return false
    end
  end
  
  def destroy_without_callbacks
    # see if someone above us tried to roll back.
    return false if callback(:before_destroy) == false
    mark_as_destroyed
    #allow the after_destroy
    callback(:after_destroy)
    self
  end

  def too_near_to_delete
    (reserved_dates.first.date - Date.today <= 1)?true:false
  end

  def calendar_strip_text(user)
    if creator == user
      "#{board.creator.full_name}: #{board.location.locality}"
    else
      if board.name.blank?
        "#{board.model} by #{board.maker}: #{creator.full_name}"
      else
        "#{board.name}: #{creator.full_name}"
      end
     
    end
  end
  
  def total_cost
    cost = 0
    num_days = self.reserved_dates.count
    daily_fee = self.board.daily_fee
    weekly_fee = self.board.weekly_fee
    if (self.board.for_purchase?)
      cost = self.board.purchase_price
    elsif weekly_fee.nil?
      cost = num_days * daily_fee
    elsif num_days < 7
      cost = (daily_fee * num_days < weekly_fee)?daily_fee*num_days:weekly_fee
    elsif num_days >= 7
      num_weeks = num_days / 7
      remainder_days = num_days % 7
      final_week_cost = (daily_fee * remainder_days < weekly_fee)?daily_fee*remainder_days:weekly_fee
      weeks_cost = num_weeks * weekly_fee
      cost = weeks_cost + final_week_cost
    end
    return cost
  end

  protected

  def mark_as_destroyed
    self.update_attribute(:deleted_at, Time.now.utc)
  end

  def board_must_be_active
    if board
      errors.add_to_base("This board got snaked while you were reserving it. Sorry. Try another one.") unless self.board.active?
    end
  end

end

