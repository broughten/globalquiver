require 'spec_helper'

describe Location do
  before(:each) do
    @valid_attributes = {
      :street => "value for street",
      :locality => "value for locality",
      :region => "value for region",
      :postal_code => "value for postal_code",
      :country => "value for country",
      :created_at => Time.now,
      :updated_at => ,
      :creator_id => 1,
      :updater_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Location.create!(@valid_attributes)
  end
end
