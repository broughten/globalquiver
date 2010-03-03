require 'spec_helper'

describe UnavailableDate do

  it "should create a new instance from blueprint" do
    UnavailableDate.make().should be_valid
  end

  describe "associations" do
    it "should have a board" do
      UnavailableDate.make().should respond_to(:parent)
      UnavailableDate.make().should respond_to(:parent_id)
    end

    it "should have a date" do
      UnavailableDate.make().should respond_to(:date)
    end

    it "should have a creator" do
      UnavailableDate.make().should respond_to(:creator)
      UnavailableDate.make().should respond_to(:creator_id)
    end

    it "should have a updater" do
      UnavailableDate.make().should respond_to(:updater)
      UnavailableDate.make().should respond_to(:updater_id)
    end
  end

  describe "validations" do
    it "should not allow two entries with the same date, parent id and parent type" do
      unavailabledate = UnavailableDate.make(:for_board)

      unavailabledate2 = UnavailableDate.make_unsaved(:parent => unavailabledate.parent, :date => unavailabledate.date)

      unavailabledate2.should_not be_valid
      
      unavailabledate2 = UnavailableDate.make_unsaved(:for_reservation,:date => unavailabledate.date)
      unavailabledate2.should be_valid
    end
    
    it "should not allow more than one entry with the same date if the parent is a reservation for a specific board" do
      reservation = Reservation.make(:board=>SpecificBoard.make())
      unavailable_date1 = UnavailableDate.make(:parent=>reservation)
      
      unavailable_date2 = UnavailableDate.make_unsaved(:parent=>reservation,:date => unavailable_date1.date)
      unavailable_date2.should_not be_valid
      
      unavailable_date2 = UnavailableDate.make_unsaved(:parent=>reservation)
      unavailable_date2.should be_valid
    end
    
    it "should allow more than one entry with the same dateif the parent is a reservation for a generic board" do
      reservation = Reservation.make(:board=>GenericBoard.make())
      unavailable_date1 = UnavailableDate.make(:parent=>reservation)
      
      unavailable_date2 = UnavailableDate.make_unsaved(:parent=>reservation,:date => unavailable_date1.date)
      unavailable_date2.should be_valid
    end

    it "should not allow you to make a new unavailable date that is in the past" do
      unavailabledate = UnavailableDate.make_unsaved(:date => 2.days.ago)
      unavailabledate.should_not be_valid
    end
    
    it "should allow you to update an unavailable date to a date in the past" do
      # we need this functionality in case we have existing unavailable dates 
      # in the past when we update black out dates for boards. 
      unavailabledate = UnavailableDate.make()
      unavailabledate.date = 2.days.ago
      unavailabledate.should be_valid
    end

    it "should not allow you to create an unavailable date without a date" do
      unavailabledate = UnavailableDate.make_unsaved(:date => nil)

      unavailabledate.should_not be_valid
    end
  end
  
  describe "named scopes" do
    it "should find recently created unavailable dates based on a passed in date" do
      unavailable_date1 = UnavailableDate.make()
      unavailable_date2 = UnavailableDate.make()
      result = UnavailableDate.created_since(2.days.ago)
      result.should include(unavailable_date1)
      result.length.should == 2
      
      unavailable_date1.created_at = 4.days.ago
      unavailable_date1.save
      result = UnavailableDate.created_since(2.days.ago)
      result.should_not include(unavailable_date1)
      result.length.should == 1      
    end
    
    
    it "should be able to filter based on who created the unavailable date" do
      unavailable_date1 = UnavailableDate.make()
      unavailable_date2 = UnavailableDate.make()
      UnavailableDate.created_by(unavailable_date1.creator).should include(unavailable_date1)
      UnavailableDate.created_by(unavailable_date1.creator).should_not include(unavailable_date2)
    end
    
    it "should be able to filter based on who didn't create the unavailable date" do
      unavailable_date1 = UnavailableDate.make()
      unavailable_date2 = UnavailableDate.make()
      UnavailableDate.not_created_by(unavailable_date1.creator).should_not include(unavailable_date1)
      UnavailableDate.not_created_by(unavailable_date1.creator).should include(unavailable_date2)
    end
    
    it "should be able to tell if it is part of a generic board reservation" do
      reservation = Reservation.make(:board=>GenericBoard.make())
      unavailable_date = UnavailableDate.make(:parent=>reservation)
      
      unavailable_date.is_for_generic_board_reservation?.should be_true
      
      reservation = Reservation.make(:board=>SpecificBoard.make())
      unavailable_date = UnavailableDate.make(:parent=>reservation)
      
      unavailable_date.is_for_generic_board_reservation?.should be_false
      
      # this is a blackout date and not associated with a reservation
      unavailable_date = UnavailableDate.make(:parent=>SpecificBoard.make())
      
      unavailable_date.is_for_generic_board_reservation?.should be_false
    end
  end
 

end
