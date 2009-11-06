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
  
end