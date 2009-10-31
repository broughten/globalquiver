require File.dirname(__FILE__) + '/../spec_helper'

describe BoardSearch do
  it "should be valid from the blueprint" do
    BoardSearch.make()
  end
  
  describe "associations" do
    it "should have a style" do
      BoardSearch.make_unsaved().should respond_to(:style)
    end
    
    it "should have a geocode" do
      BoardSearch.make_unsaved().should respond_to(:geocode)
    end
  end
  
  describe "validations" do
    it "should validate the presence of a geocode" do
      board_search = BoardSearch.make()
       
      board_search.geocode = nil
      board_search.should_not be_valid
    end
    
  end
  
  
end
