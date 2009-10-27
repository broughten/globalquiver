require 'spec_helper'

describe BlackOutDate do

  it "should create a new instance from blueprint" do
    BlackOutDate.make().should be_valid
  end

  describe "associations" do
    it "should have a board" do
      BlackOutDate.make().should respond_to(:board)
    end

    it "should have a date" do
      BlackOutDate.make().should respond_to(:date)
    end
  end

  describe "validations" do
    it "should not allow two entries with the same date and board id" do
      blackoutdate = BlackOutDate.make

      blackoutdate2 = BlackOutDate.make_unsaved(:board_id => blackoutdate.board_id, :date => blackoutdate.date)

      blackoutdate2.should_not be_valid
    end

    it "should not allow you to make a new black out date that is in the past" do
      blackoutdate = BlackOutDate.make_unsaved(:date => 1.day.ago)
      blackoutdate.should_not be_valid
    end

    it "should not allow you to create a black out date without a date" do
      blackoutdate = BlackOutDate.make_unsaved(:date => nil)

      blackoutdate.should_not be_valid
    end

    it "should not allow you to create a black out date without a board" do
      blackoutdate = BlackOutDate.make_unsaved(:board => nil)

      blackoutdate.should_not be_valid
    end
 
    it "should not allow you to create a blackout date for a board_id that doesn't exist" do
      blackoutdate = BlackOutDate.make_unsaved(:board_id => 49)
      blackoutdate.should_not be_valid
    end
  end


end
