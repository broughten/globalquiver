class UnavailableDate < ActiveRecord::Base
  acts_as_reserved_date

  belongs_to :parent, :polymorphic => true
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'


  validates_uniqueness_of :date, 
    :scope => [:parent_id, :parent_type],
    :message => 'This board was already unavailable on the selected date.',
    :unless => :is_for_generic_board_reservation?

  validates_is_after :date, :on=>:create # makes sure the date is in the future but only when it is created

  validates_presence_of :date
  
  named_scope :created_since, lambda { |time| {:conditions => ["unavailable_dates.created_at > ?", time]} }
  named_scope :created_by, lambda { |user| {:conditions => ['unavailable_dates.creator_id = ?', (user.nil?)?-1:user.id]} }
  named_scope :not_created_by, lambda { |user| {:conditions => ['unavailable_dates.creator_id != ?', (user.nil?)?-1:user.id]} }
  
  def is_for_generic_board_reservation?
    self.parent.is_a?(Reservation) && self.parent.board.is_generic?
  end
end
