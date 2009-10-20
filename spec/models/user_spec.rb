require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  it "should succeed creating a new valid from the blueprint" do
    User.make().should be_valid
  end

  it "should have many boards" do
    user = User.make()
    Board.make(:creator=>user)
    Board.make(:creator=>user)
    user.boards.length.should == 2
  end
  
  it "should have many locations" do
    user = User.make()
    Location.make(:creator=>user)
    Location.make(:creator=>user)
    user.locations.length.should == 2
  end

  it "should authenticate with matching email and password" do
    user = User.make(:first_name => 'Kelly', :last_name => 'slater', :email => 'sl8ter@domain.com')
    User.authenticate('sl8ter@domain.com', 'good_password').should == user
  end

  it "should not authenticate with incorrect password" do
    user = User.make(:first_name => 'Kelly', :last_name => 'slater', :email => 'sl8ter@domain.com')
    User.authenticate('sl8ter@domain.com', 'boogieboardforever!').should be_nil
  end



end