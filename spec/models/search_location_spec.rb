require 'spec_helper'

describe SearchLocation do
  
  it "should create a new instance from blueprint" do
    SearchLocation.make().should be_valid 
  end
  
  it "should inherit from Location" do
    SearchLocation.make_unsaved().should be_a_kind_of(Location)
  end
  
  describe "validations" do
    it_should_validate_presence_for_attributes SearchLocation.make_unsaved(), :search_radius
  end
  
  describe "methods" do
    it "should respond to a to_s method that returns 'locality, region country'" do
      location = SearchLocation.make_unsaved()
      location.to_s.should == "#{location.locality}, #{location.region} #{location.country}"
    end
    
  end
  
end