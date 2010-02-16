require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'spec_helper'

describe SpecificBoard do

  it "should create a new instance from blueprint" do
    SpecificBoard.make().should be_valid
  end
  

  
  describe "validations" do

    it "should validate length" do
      specific_board = SpecificBoard.make_unsaved(:length=>100)
      specific_board.should be_valid
      
      specific_board.length = nil
      specific_board.should_not be_valid
      
    end
   
    it "should validate maker" do
      specific_board = SpecificBoard.make_unsaved(:maker=>"Test Maker")
      specific_board.should be_valid
      
      specific_board.maker = ""
      specific_board.should_not be_valid
    end

  end

end
