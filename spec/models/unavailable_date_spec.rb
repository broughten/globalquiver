require 'spec_helper'

describe UnavailableDate do

  it "should create a new instance from blueprint" do
    UnavailableDate.make().should be_valid
  end

  describe "associations" do
    it "should have a board" do
      UnavailableDate.make().should respond_to(:board)
    end

    it "should have a date" do
      UnavailableDate.make().should respond_to(:date)
    end

    it "should have a creator" do
      UnavailableDate.make().should respond_to(:creator)
    end

    it "should have a updater" do
      UnavailableDate.make().should respond_to(:updater)
    end
  end

  describe "validations" do
    it "should not allow two entries with the same date and board id" do
      unavailabledate = UnavailableDate.make

      unavailabledate2 = UnavailableDate.make_unsaved(:board_id => unavailabledate.board_id, :date => unavailabledate.date)

      unavailabledate2.should_not be_valid
    end

    it "should not allow you to make a new unavailable date that is in the past" do
      unavailabledate = UnavailableDate.make_unsaved(:date => 2.days.ago)
      unavailabledate.should_not be_valid
    end

    it "should not allow you to create an unavailable date without a date" do
      unavailabledate = UnavailableDate.make_unsaved(:date => nil)

      unavailabledate.should_not be_valid
    end

  end


end