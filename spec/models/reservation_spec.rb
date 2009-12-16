require 'spec_helper'

describe Reservation do
  
  it "should create a vaild model from blueprint" do
    reservation = Reservation.make()
    reservation.should be_valid
  end
  
  describe "associations" do
    it "should have a creator" do
      Reservation.make_unsaved().should respond_to(:creator)
      # confirm the db columns are right
      Reservation.make_unsaved().should respond_to(:creator_id)
    end
    
    it "should have an updater" do
      Reservation.make_unsaved().should respond_to(:updater)
      # confirm the db columns are right
      Reservation.make_unsaved().should respond_to(:updater_id)
    end
    
    it "should have a board" do
      Reservation.make_unsaved().should respond_to(:board)
      # confirm the db columns are right
      Reservation.make_unsaved().should respond_to(:board_id)
    end
    
    it "should have many dates" do
      Reservation.make_unsaved().should respond_to(:reservation_dates)
    end
  end
  
  describe "validations" do
    before(:each) do
      @reservation = Reservation.make_unsaved()
    end
    it "should contain at least one date" do
      @reservation.reservation_dates = []
      @reservation.should_not be_valid
    end
    
    it "should have a board" do
      @reservation.board = nil
      @reservation.should_not be_valid
    end
  end
  
  describe "named scopes" do
    it "should be able to find reservations for a user" do
      renter = User.make()
      non_renter = User.make()
      reservation = Reservation.make(:creator=>renter)
      Reservation.for_user(renter).should include(reservation)
      
      Reservation.for_user(non_renter).should be_empty
    end
    
    it "should be able to find new reservations for a time frame" do
      reservation = Reservation.make(:created_at=>2.days.ago)
      Reservation.created_since(1.day.ago).should_not include(reservation)
      Reservation.created_since(3.days.ago).should include(reservation)
    end

    it "should find recently deleted reservations based on a passed in date" do
      reservation1 = Reservation.make(:deleted)
      reservation2 = Reservation.make(:deleted)
      result = Reservation.deleted_since(2.days.ago)
      result.should include(reservation1)
      result.length.should == 2

      reservation1.deleted_at = 4.days.ago
      reservation1.save
      result = Reservation.deleted_since(2.days.ago)
      result.should_not include(reservation1)
      result.length.should == 1
    end



    it "should contain inactive that only returns the inactive records" do
      reservation1 = Reservation.make()
      reservation2 = Reservation.make()
      reservation2.destroy()
      results = Reservation.inactive
      results.should_not include(reservation1)
      results.should include(reservation2)
    end



    it "should contain active that only returns the deleted records" do
      reservation1 = Reservation.make()
      reservation2 = Reservation.make()
      reservation2.destroy()
      results = Reservation.active
      results.should include(reservation1)
      results.should_not include(reservation2)
    end
 
  end

  it "should soft delete a record by setting deleted_at" do
    reservation = Reservation.make()
    reservation.deleted_at.should be_nil

    reservation.destroy
    reservation.deleted_at.should_not be_nil
  end



  it "should allow new record to be added if a deleted one exists" do
    deleted_reservation = Reservation.make(:deleted)
    new_reservation = Reservation.make(:reservation_dates=>deleted_reservation.reservation_dates)
    new_reservation.should_not be_new_record
  end
  
  
end