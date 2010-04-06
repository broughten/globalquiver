class Invoice < ActiveRecord::Base
  belongs_to :responsible_user , :class_name => "User"
  has_many :reservations
  
  validates_presence_of :responsible_user, :due_date
  
  named_scope :for_user, lambda { |user| {:conditions => ['invoices.responsible_user_id = ?', user.id]} }
  
  def self.create_invoices_for_uninvoiced_reservations
    shops = Shop.with_uninvoiced_reservations
    invoices = []
    shops.each do |shop|
      invoice = Invoice.new()
      invoice.responsible_user = shop
      invoice.due_date = 30.days.from_now.to_date
      shop.reservations_for_owned_boards.uninvoiced.each do |reservation|
        invoice.reservations << reservation
      end
      invoice.save
      invoices << invoice
    end
    invoices
  end
  
  def self.create_and_email_new_invoice_notifications
    create_invoices_for_uninvoiced_reservations.each do |invoice|
      UserMailer.deliver_invoice_notification(invoice) 
    end
  end
  
  def total
    total_days = 0
    self.reservations.each do |reservation|
      total_days = total_days + reservation.reserved_dates.count
    end
    total_days * responsible_user.reservation_invoice_fee
  end

end
