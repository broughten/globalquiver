class BlackOutDate < ActiveRecord::Base
  belongs_to :board

  validates_uniqueness_of :date, :scope => :board_id,
    :message => 'There black out date was already set for this board.'

  validates_is_after :date

  validates_presence_of :board_id, :date

  validates_existence_of :board

end
