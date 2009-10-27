require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  
  it "should succeed creating a new valid from the blueprint" do
    User.make().should be_valid
  end
  
  describe "model associations" do
    it "should allow one image" do
      User.make().should respond_to(:image)
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
    
  end
  
  describe "attribute validations" do
    it "should only allow an email address that contains a @ character" do
      user = User.make_unsaved(:email=>"badEmail")
      user.should_not be_valid
      
      user = User.make_unsaved(:email=>"email@email.com")
      user.should be_valid
    end
    
    it "should not allow duplicate email addresses" do
      user = User.make()
      user2 = User.make_unsaved(:email=>user.email)
      user2.should_not be_valid
    end
    
    it "should only allow passwords that are between 4 and 40 characters" do
      user = User.make_unsaved(:password=>"123")
      user.should_not be_valid
      
      user = User.make_unsaved(:password=>"12345")
      user.should be_valid
     
      user = User.make_unsaved(:password=>Faker::Lorem.words(41))
      user.should_not be_valid
    end
  end
  
  describe "authentication" do
    it "should authenticate with matching email and password" do
      user = User.make(:first_name => 'Kelly', :last_name => 'slater', :email => 'sl8ter@domain.com')
      User.authenticate('sl8ter@domain.com', 'good_password').should == user
    end

    it "should not authenticate with incorrect password" do
      user = User.make(:first_name => 'Kelly', :last_name => 'slater', :email => 'sl8ter@domain.com')
      User.authenticate('sl8ter@domain.com', 'boogieboardforever!').should be_nil
    end
  end
  
  it "should not think that it is a shop" do
      user = User.make()
      is_shop = user.is_rental_shop?
      is_shop.should == false
  end
  
  it "should not return anything for display_name" do
    user = User.make()
    display_name = user.display_name
    display_name.should == ""
  end
  
  it "should should return an empty string for full_name" do
    user = User.make()
    user.full_name.should == ""
  end
end