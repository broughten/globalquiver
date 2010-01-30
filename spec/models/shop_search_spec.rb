require File.dirname(__FILE__) + '/../spec_helper'

describe ShopSearch do
  it "should be valid from the blueprint" do
    ShopSearch.make()
  end
  
  describe "associations" do
    
    it "should allow a location" do
      ShopSearch.make_unsaved().should respond_to(:location)
      # confirm the db columns are right
      ShopSearch.make_unsaved().should respond_to(:location_id)
    end
    
    it "should have a creator" do
      ShopSearch.make_unsaved().should respond_to(:creator)
      # confirm the db columns are right
      ShopSearch.make_unsaved().should respond_to(:creator_id)
    end
    
    it "should have an updater" do
      ShopSearch.make_unsaved().should respond_to(:updater)
      # confirm the db columns are right
      ShopSearch.make_unsaved().should respond_to(:updater_id)
    end
  end
  
  describe "validations" do
  end
  
  describe "methods" do
    
    it "should respond to an execute method" do
      shop_search = ShopSearch.make()
      shop_search.should respond_to(:execute)
    end
    
    it "execute should return an array" do
      shop_search = make_shop_search()
      results = shop_search.execute
      results.should be_instance_of(Array)
    end
    
    it "execute should return Shop objects" do
      shop1 = Shop.make(:location=>UserLocation.make(:santa_barbara_ca))
      search_location = SearchLocation.make(:locality=>shop1.location.locality, :region=>shop1.location.region, :country=>shop1.location.country)
      
      shop_search = ShopSearch.make(:location=>search_location)
      result = shop_search.execute
      result.first.should be_instance_of(Shop)
    end
    
    it "execute should filter results based on location" do
      shop1 = Shop.make(:location=>UserLocation.make(:santa_barbara_ca))
      # this shop comes back with a location that is a mix of the UserLocation.make(:santa_barbara_ca)
      # blueprint and the Location.make() blueprint.  This is why the geocoding is failing.
      shop2 = Shop.make(:location=>shop1.location)
      shop2.location = shop1.location
      shop2.save
      search_location = SearchLocation.make(:locality=>shop1.location.locality, :region=>shop1.location.region, :country=>shop1.location.country)
      shop_search = ShopSearch.make(:location=>search_location)
      result = shop_search.execute
      result.should include(shop1)
      result.should include(shop2)
      
      #change location
      shop2.location = UserLocation.make(:des_plaines_il)
      # make sure you save the new state away into the db.
      shop2.save
      result = shop_search.execute
      #result.include?(shop1).should be_true
      result.should include(shop1)
      result.should_not include(shop2)
    end

    it "execute should filter results based on name" do
      shop1 = Shop.make(:location=>UserLocation.make(:santa_barbara_ca))
      # this shop comes back with a location that is a mix of the UserLocation.make(:santa_barbara_ca)
      # blueprint and the Location.make() blueprint.  This is why the geocoding is failing.
      shop2 = Shop.make(:location=>shop1.location)
      search_location = SearchLocation.make(:locality=>shop1.location.locality, :region=>shop1.location.region, :country=>shop1.location.country)
      shop_search = ShopSearch.make(:location=>search_location,:terms=>nil)
      result = shop_search.execute
      result.should include(shop1)
      result.should include(shop2)
      
      #change shop_search name to something
      shop_search.terms = shop1.name
      result = shop_search.execute
      result.should include(shop1)
      result.should_not include(shop2)
    end
   
  end  
end
