class Invoice < ActiveRecord::Base
  belongs_to :responsible_user , :class_name => "User"
  has_many :reservations
  
  validates_presence_of :responsible_user, :due_date
  
  named_scope :for_user, lambda { |user| {:conditions => ['invoices.responsible_user_id = ?', user.id]} }
  
  def total
    the_total = 0
    self.reservations.each do |reservation|
      the_total = the_total + reservation.total_cost
    end
    the_total
  end
  
end
