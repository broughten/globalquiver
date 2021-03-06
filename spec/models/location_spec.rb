require 'spec_helper'

describe Location do

  describe "blueprint test" do
    it "should create a new instance from blueprint" do
      Location.make().should be_valid
    end
  end

  
  describe "associations" do
    it "should belong to a creator" do
      Location.make_unsaved().should belong_to(:creator)
    end
    
    it "should belong to a updater" do
      Location.make_unsaved().should belong_to(:updater)
    end

  end
  
  describe "methods" do
    it "should respond to a to_s method that returns 'locality, region country'" do
      location = SearchLocation.make_unsaved()
      location.to_s.should == "#{location.locality}, #{location.region} #{location.country}"
    end
    
  end

  describe "named scopes" do
    it "should have a named scope that allows you to get locations ordered by descending created_at date" do
      location1 = Location.make(:created_at => 1.day.from_now)
      location2 = Location.make(:created_at => 2.days.from_now)
      locations = Location.ordered_by_desc_creation

      locations.index(location2).should < locations.index(location1)
    end
  end

  
  it "should determine if the current location matches another location" do
    # all of the attributes should be different
    location1 = Location.make_unsaved()
    location2 = Location.make_unsaved()
    location1.matches?(location2).should_not == true
    
    #attributes are all the same
    location1 = location2.clone()
    location1.matches?(location2).should == true    
  end
end
