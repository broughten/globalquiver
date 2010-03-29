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
      invoice = Invoice.make()
      
      invoice.total.should == 0
      
      res1 = Reservation.make()
      res2 = Reservation.make()
      invoice.reservations << res1
      invoice.reservations << res2
      
      invoice.total.should == res1.total_cost + res2.total_cost
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
  
  
end
