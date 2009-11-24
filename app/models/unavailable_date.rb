class UnavailableDate < ActiveRecord::Base
  belongs_to :board
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'


  validates_uniqueness_of :date, :scope => :board_id,
    :message => 'This board was already unavailable on the selected date.'

  validates_is_after :date

  validates_presence_of :date
  
  named_scope :recently_created, lambda { |time| {:conditions => ["created_at > ?", time]} }
  named_scope :inactive, :conditions => ["deleted_at IS NOT ?", nil]
  named_scope :active, :conditions => ["deleted_at IS ?", nil]
    
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
