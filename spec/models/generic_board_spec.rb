require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'spec_helper'

describe GenericBoard do

  it "should create a new instance from blueprint" do
    GenericBoard.make().should be_valid
  end
  

  
  describe "validations" do

    it "should validate lower length" do
      generic_board = GenericBoard.make_unsaved(:lower_length=>1)
      generic_board.should be_valid
      
      generic_board.lower_length = nil
      generic_board.should_not be_valid
      
    end


    it "should validate upper length" do
      generic_board = GenericBoard.make_unsaved(:upper_length=>110)
      generic_board.should be_valid

      generic_board.upper_length = nil
      generic_board.should_not be_valid

    end

    it "should require upper length to be a number" do
      generic_board = GenericBoard.make_unsaved(:upper_length=>110)
      generic_board.should be_valid

      generic_board.upper_length = "hello"
      generic_board.should_not be_valid
    end

    it "should require lower length to be a number" do
      generic_board = GenericBoard.make_unsaved(:lower_length =>1)
      generic_board.should be_valid

      generic_board.lower_length = "bye"
      generic_board.should_not be_valid
    end

  end

end
