require 'spec_helper'

describe BoardLocation do
  
  it "should create a new instance from blueprint" do
    BoardLocation.make_unsaved().should be_valid 
  end
  
  it "should inherit from Location" do
    BoardLocation.make_unsaved().should be_a_kind_of(Location)
  end
  
  describe "validations" do
    it_should_validate_presence_for_attributes BoardLocation.make_unsaved(), :street, :postal_code
  end
  
  describe "associations" do
    it "should have many boards" do
      BoardLocation.make().should have_many(:boards)
    end
  end
end