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
    it "should contain at least one date" do
      reservation = Reservation.make_unsaved()
      reservation.reservation_dates = []
      reservation.should_not be_valid
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
  
  end
  
  
end