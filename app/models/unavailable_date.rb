class UnavailableDate < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true
  belongs_to :creator, :class_name => 'User'
  belongs_to :updater, :class_name => 'User'


  validates_uniqueness_of :date, :scope => [:parent_id, :parent_type],
    :message => 'This board was already unavailable on the selected date.'

  validates_is_after :date, :on=>:create # makes sure the date is in the future but only when it is created

  validates_presence_of :date
  
  named_scope :created_since, lambda { |time| {:conditions => ["unavailable_dates.created_at > ?", time]} }
  named_scope :deleted_since, lambda { |time| {:conditions => ["unavailable_dates.deleted_at > ?", time]} }
  named_scope :inactive, :conditions => ["unavailable_dates.deleted_at IS NOT ?", nil]
  named_scope :active, :conditions => ["unavailable_dates.deleted_at IS ?", nil]
  named_scope :created_by, lambda { |user| {:conditions => ['unavailable_dates.creator_id = ?', (user.nil?)?-1:user.id]} }
  named_scope :not_created_by, lambda { |user| {:conditions => ['unavailable_dates.creator_id != ?', (user.nil?)?-1:user.id]} }
    
  before_validation_on_create :remove_soft_deleted_record
    
  def destroy
    # see if someone above us tried to roll back.
    return false if callback(:before_destroy) == false
    mark_as_destroyed
    #allow the after_destroy
    callback(:after_destroy)
    self
  end
  
  protected
  def remove_soft_deleted_record
    # we need to check to see if there is a soft deleted record in the
    # db and delete it so the validation are OK
    # there should be only one
    found_records = UnavailableDate.all(:conditions => ["parent_id = ? AND parent_type = ? AND date = ? AND deleted_at IS NOT ?", self.parent_id, self.parent_type, self.date, nil]) 
    found_records.each {|record| record.delete}
  end
  
  def mark_as_destroyed
    self.update_attribute(:deleted_at, Time.now.utc)
  end
  
end
