require 'spec_helper'

describe Location do
  
  it "should create a new instance from blueprint" do
    Location.make().should be_valid 
  end
  
  it "should have a named scope that allows you to get locations ordered by descending created_at date" do
    location1 = Location.make()
    location2 = Location.make()
    locations = Location.ordered_by_desc_creation
    
    locations[0].should == location2
  end
end
