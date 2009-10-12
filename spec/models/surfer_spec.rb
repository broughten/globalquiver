require File.dirname(__FILE__) + '/../spec_helper'

describe Surfer do

  it "should succeed creating a new valid from the blueprint" do
    Surfer.make().should be_valid
  end

  it "should fail if first name is blank" do
    # use make_unsaved here so the validation doesn't kick in until you
    # ask the object if it is valid or not
    Surfer.make_unsaved(:first_name=>"",:last_name=>"").should_not be_valid
  end

  it "should authenticate with matching email and password" do
    surfer = Surfer.make(:first_name => 'Kelly', :last_name => 'slater', :email => 'sl8ter@domain.com')
    User.authenticate('sl8ter@domain.com', 'good_password').should == surfer
  end

  it "should not authenticate with incorrect password" do
    surfer = Surfer.make(:first_name => 'Kelly', :last_name => 'slater', :email => 'sl8ter@domain.com')
    User.authenticate('sl8ter@domain.com', 'boogieboardforever!').should be_nil
  end

end