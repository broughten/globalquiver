require File.dirname(__FILE__) + '/../spec_helper'

describe Surfer do

  it "should succeed creating a new valid from the blueprint" do
    Surfer.make().should be_valid
  end

  it "should fail if first name is blank" do
    # use make_unsaved here so the validation doesn't kick in until you
    # ask the object if it is valid or not
    Surfer.make_unsaved(:first_name=>"").should_not be_valid
  end

  it "should return it's first name as it's display name" do
    surfer = Surfer.make()
    surfer.display_name.should == surfer.first_name
  end
  
  it "should return first name and last name separated by space for full name" do
    surfer = Surfer.make()
    surfer.full_name.should == "#{surfer.first_name} #{surfer.last_name}"
  end
  
  it "should inherit from User" do
    Surfer.make_unsaved().should be_a_kind_of(User)
  end
  

end