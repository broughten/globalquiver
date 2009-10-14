require 'spec_helper'

describe Board do

  it "should create a new instance from blueprint" do
    Board.make().should be_valid
  end
end
