class UnavailableDate < ActiveRecord::Base
  belongs_to :board
  belongs_to :user
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'


  validates_uniqueness_of :date, :scope => :board_id,
    :message => 'There unavailable date was already set for this board.'


  validates_is_after :date

  validates_presence_of :date
  
end
