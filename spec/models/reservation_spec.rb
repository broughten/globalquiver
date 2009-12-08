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
      Reservation.make_unsaved().should respond_to(:dates)
    end
  end
  
  describe "validations" do
    it "should contain at least one date" do
      reservation = Reservation.make()
      reservation.dates = []
      reservation.should_not be_valid
    end
  end
  
  
end