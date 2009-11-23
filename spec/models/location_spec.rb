require 'spec_helper'

describe Location do
  
  it "should create a new instance from blueprint" do
    Location.make().should be_valid 
  end
  
  describe "validations" do
    it_should_validate_presence_for_attributes Location.make_unsaved(), :locality, :region, :country
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
  
  it "should have a named scope that allows you to get locations ordered by descending created_at date" do
    location1 = Location.make()
    location2 = Location.make()
    locations = Location.ordered_by_desc_creation
    
    locations[0].should == location2
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
