class UnavailableDate < ActiveRecord::Base
  belongs_to :board
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'


  validates_uniqueness_of :date, :scope => :board_id,
    :message => 'This board was already unavailable on the selected date.'

  validates_is_after :date

  validates_presence_of :date
  
  named_scope :recently_created, lambda { |time| {:conditions => ["created_at > ?", time]} }
  
end
