require 'spec_helper'

describe BlackOutDate do

  it "should create a new instance from blueprint" do
    BlackOutDate.make().should be_valid
  end

  
  it "should not allow two entries with the same date and board id"

end
