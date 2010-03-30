class Invoice < ActiveRecord::Base
  belongs_to :responsible_user , :class_name => "User"
  has_many :reservations
  
  validates_presence_of :responsible_user, :due_date
  
  named_scope :for_user, lambda { |user| {:conditions => ['invoices.responsible_user_id = ?', user.id]} }
  
  def total
    total_days = 0
    self.reservations.each do |reservation|
      total_days = total_days + reservation.reserved_dates.count
    end
    total_days * responsible_user.reservation_invoice_fee
  end
  
end
