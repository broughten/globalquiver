require File.dirname(__FILE__) + '/../spec_helper'

describe Shop do

  it "should succeed creating a new valid from the blueprint" do
    Shop.make().should be_valid
  end

  it "should fail if name is blank" do
    # use make_unsaved here so the validation doesn't kick in until you
    # ask the object if it is valid or not
    Shop.make_unsaved(:name=>"").should_not be_valid
  end

end