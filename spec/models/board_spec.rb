require 'spec_helper'

describe Board do
  before(:each) do
    @valid_attributes = {
      :maker => "value for maker",
      :model => "value for model",
      :length => 1,
      :width => 1.5,
      :thickness => 1.5,
      :style_id => 1,
      :user_id => 1,
      :description => "value for description",
      :created_at => Time.now,
      :updated_at => Time.now,
      :location_id => 1,
      :construction => "value for construction",
      :creator_id => 1,
      :updater_id => "value for updater_id"
    }
  end

  it "should create a new instance given valid attributes" do
    Board.create!(@valid_attributes)
  end
end
