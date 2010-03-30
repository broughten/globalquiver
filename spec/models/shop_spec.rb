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
  
  it "should return it's name as the display name" do
    shop = Shop.make()
    shop.display_name.should == shop.name
  end
  
  it "should return it's name as the full name" do
    shop = Shop.make()
    shop.full_name.should == shop.name
  end
  
  it "should think that it is a shop" do
    is_shop = Shop.make().is_rental_shop?
    is_shop.should == true
  end
  
  it "should inherit from User" do
    Shop.make_unsaved().should be_a_kind_of(User)
  end
  
  it "should allow you to find all shops with uninvoiced reservations" do
    uninvoiced_shop = make_uninvoiced_reservation_and_get_shop
    invoiced_shop = make_invoiced_reservation_and_get_shop
    
    Shop.with_uninvoiced_reservations.should include(uninvoiced_shop)
    Shop.with_uninvoiced_reservations.should_not include(invoiced_shop)
  end

end