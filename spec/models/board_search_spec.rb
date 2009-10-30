require File.dirname(__FILE__) + '/../spec_helper'

describe BoardSearch do
  it "should be valid" do
    BoardSearch.new.should be_valid
  end
  
end
