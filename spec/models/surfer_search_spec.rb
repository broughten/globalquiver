require File.dirname(__FILE__) + '/../spec_helper'

describe SurferSearch do
  it "should be valid from the blueprint" do
    SurferSearch.make()
  end
  
  describe "associations" do
    
    it "should allow a location" do
      SurferSearch.make_unsaved().should respond_to(:location)
      # confirm the db columns are right
      SurferSearch.make_unsaved().should respond_to(:location_id)
    end
    
    it "should have a creator" do
      SurferSearch.make_unsaved().should respond_to(:creator)
      # confirm the db columns are right
      SurferSearch.make_unsaved().should respond_to(:creator_id)
    end
    
    it "should have an updater" do
      SurferSearch.make_unsaved().should respond_to(:updater)
      # confirm the db columns are right
      SurferSearch.make_unsaved().should respond_to(:updater_id)
    end
  end
  
  describe "validations" do
  end
  
  describe "methods" do
    
    it "should respond to an execute method" do
      surfer_search = SurferSearch.make()
      surfer_search.should respond_to(:execute)
    end
    
    it "execute should return an array" do
      surfer_search = make_surfer_search()
      results = surfer_search.execute
      results.should be_instance_of(Array)
    end
    
    it "execute should return Surfer objects" do
      surfer1 = Surfer.make(:location=>UserLocation.make(:santa_barbara_ca))
      search_location = SearchLocation.make(:locality=>surfer1.location.locality, :region=>surfer1.location.region, :country=>surfer1.location.country)
      
      surfer_search = SurferSearch.make(:location=>search_location)
      result = surfer_search.execute
      result.first.should be_instance_of(Surfer)
    end
    
    it "execute should filter results based on location" do
      surfer1 = Surfer.make(:location=>UserLocation.make(:santa_barbara_ca))
      # this surfer comes back with a location that is a mix of the UserLocation.make(:santa_barbara_ca)
      # blueprint and the Location.make() blueprint.  This is why the geocoding is failing.
      surfer2 = Surfer.make(:location=>surfer1.location)
      surfer2.location = surfer1.location
      surfer2.save
      search_location = SearchLocation.make(:locality=>surfer1.location.locality, :region=>surfer1.location.region, :country=>surfer1.location.country)
      surfer_search = SurferSearch.make(:location=>search_location)
      result = surfer_search.execute
      result.should include(surfer1)
      result.should include(surfer2)
      
      #change location
      surfer2.location = UserLocation.make(:des_plaines_il)
      # make sure you save the new state away into the db.
      surfer2.save
      result = surfer_search.execute
      #result.include?(surfer1).should be_true
      result.should include(surfer1)
      result.should_not include(surfer2)
    end

    it "execute should filter results based on name" do
      surfer1 = Surfer.make(:location=>UserLocation.make(:santa_barbara_ca))
      # this surfer comes back with a location that is a mix of the UserLocation.make(:santa_barbara_ca)
      # blueprint and the Location.make() blueprint.  This is why the geocoding is failing.
      surfer2 = Surfer.make(:location=>surfer1.location)
      search_location = SearchLocation.make(:locality=>surfer1.location.locality, :region=>surfer1.location.region, :country=>surfer1.location.country)
      surfer_search = SurferSearch.make(:location=>search_location,:terms=>nil)
      result = surfer_search.execute
      result.should include(surfer1)
      result.should include(surfer2)
      
      #change surfer_search first_name to something
      surfer_search.terms = surfer1.first_name
      result = surfer_search.execute
      result.should include(surfer1)
      result.should_not include(surfer2)
    end
   
  end  
end
