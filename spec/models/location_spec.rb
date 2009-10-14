require 'spec_helper'

describe Location do
  
  it "should create a new instance from blueprint" do
    Location.make().should be_valid 
  end
end
