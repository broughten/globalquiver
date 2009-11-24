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
  
  describe "named scopes" do
    it "should contain recently_created that filters dates based on a passed in range" do
      unavailable_date1 = UnavailableDate.make()
      unavailable_date2 = UnavailableDate.make()
      result = UnavailableDate.recently_created(2.days.ago)
      result.should include(unavailable_date1)
      result.length.should == 2
      
      unavailable_date1.created_at = 4.days.ago
      unavailable_date1.save
      result = UnavailableDate.recently_created(2.days.ago)
      result.should_not include(unavailable_date1)
      result.length.should == 1      
    end
    
    it "should contain inactive that only returns the inactive records" do
      unavailable_date1 = UnavailableDate.make()
      unavailable_date2 = UnavailableDate.make()
      unavailable_date2.destroy()
      debugger
      results = UnavailableDate.inactive
      results.should_not include(unavailable_date1)
      results.should include(unavailable_date2)     
    end
    
    it "should contain active that only returns the deleted records" do
      unavailable_date1 = UnavailableDate.make()
      unavailable_date2 = UnavailableDate.make()
      unavailable_date2.destroy()
      results = UnavailableDate.active
      results.should include(unavailable_date1)
      results.should_not include(unavailable_date2)     
    end
  end

  it "should soft delete a record by setting deleted_at" do
    date = UnavailableDate.make()
    date.deleted_at.should be_nil
    
    date.destroy
    date.deleted_at.should_not be_nil
  end

end
