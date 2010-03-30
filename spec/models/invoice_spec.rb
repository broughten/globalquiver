require 'spec_helper'

describe Invoice do
  before(:each) do
    
  end

  it "should create a new instance given valid attributes" do
    Invoice.make().should be_valid
  end
  
  describe "associations" do
    it "should associate a User with the responsible_user" do
      user = User.make()
      invoice = Invoice.make(:responsible_user => user)
      
      invoice.responsible_user.should == user
    end
    
    it "should have many reservations" do
      invoice = Invoice.make()
      res1 = Reservation.make()
      res2 = Reservation.make()
      invoice.reservations << res1
      invoice.reservations << res2
      
      invoice.reservations.should include(res1)
      invoice.reservations.should include(res2)
      
    end
  end
  
  describe "attributes" do
    it "should allow you to set/get the due date" do
      due_date = 10.days.from_now.to_date
      invoice = Invoice.make(:due_date => due_date)
      invoice.due_date.should == due_date
    end
    
    it "should allow you to get the invoice total" do
      #An empty invoice should return 0
      user = User.make(:reservation_invoice_fee=>4)
      invoice = Invoice.make(:responsible_user=>user)
      
      invoice.total.should == 0
      
      res1 = Reservation.make()
      res2 = Reservation.make()
      invoice.reservations << res1
      invoice.reservations << res2
      
      total_days = 0
      
      invoice.reservations.each do |reservation|
        total_days = total_days + reservation.reserved_dates.count
      end
      
      invoice.total.should == total_days * invoice.responsible_user.reservation_invoice_fee
      invoice.total.should > 0
    end
    
    it "should allow you to set an invoice as paid and should default to false" do
      invoice = Invoice.make()
      invoice.paid.should be_false
      
      invoice.paid = true
      invoice.paid.should be_true
      
    end
    
  end
  
  describe "validations" do
    before(:each) do
      @invoice = Invoice.make_unsaved
    end
    
    it "should require a due_date" do
      @invoice.due_date = nil
      @invoice.should_not be_valid
      
      @invoice.due_date = 10.days.from_now.to_date
      @invoice.should be_valid
    end
    
    it "should require due_date to be a valid date" do
      @invoice.should be_valid
      
      @invoice.due_date = "hello"
      @invoice.should_not be_valid
    end
    
    it "should require a responsible_user" do
      @invoice.responsible_user = nil
      @invoice.should_not be_valid
      
      @invoice.responsible_user = User.make_unsaved()
      @invoice.should be_valid
    end
  end
  
  describe "named scopes" do
    it "should be able to find reservations for a user" do
      user1 = User.make()
      user2 = User.make()
      invoice = Invoice.make(:responsible_user=>user1)
      Invoice.for_user(user1).should include(invoice)
      
      Invoice.for_user(user2).should be_empty
    end
  end
  
  it "should create new invoices for shops that have uninvoiced reservations" do
    shop_with_uninvoiced_reservation = make_uninvoiced_reservation_and_get_shop
    shop_without_uninvoiced_reservation = make_invoiced_reservation_and_get_shop
    surfer = Surfer.make()
    
    Invoice.for_user(surfer).count.should == 0
    Invoice.for_user(shop_with_uninvoiced_reservation).count.should == 0
    Invoice.for_user(shop_without_uninvoiced_reservation).count.should == 1
    
    new_invoices = Invoice.create_invoices_for_uninvoiced_reservations
    
    Invoice.for_user(surfer).count.should == 0
    Invoice.for_user(shop_with_uninvoiced_reservation).count.should == 1
    Invoice.for_user(shop_without_uninvoiced_reservation).count.should == 1
    new_invoices.count.should == 1
    new_invoices.first.reservations.count.should == 1
    new_invoices.first.responsible_user.should == shop_with_uninvoiced_reservation
    new_invoices.first.due_date.should == 30.days.from_now.to_date
    
  end
  
  
  
end
