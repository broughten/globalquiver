require 'spec_helper'

describe Style do

  it "should create a new instance from blueprint" do
    Style.make().should be_valid
  end
end
