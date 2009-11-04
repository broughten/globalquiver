require 'spec_helper'

describe "/board_locations/new" do
  
  before(:each) do
    assigns[:board_location] = BoardLocation.make_unsaved()
    @existing_locations = mock()
    assigns[:existing_locations] = @existing_locations
    @existing_locations.stubs(:empty?).returns(true)
    map = mock()
    map.stubs(:div)
    map.stubs(:to_html)
    assigns[:map] = map
  end

  it "should have a form with text fields for the required fields" do
    render "board_locations/new.html.erb"
    response.should have_selector("form[method=post]", :action => board_locations_path) do |form|
      form.should have_selector("input", :name=>"board_location[street]")
      form.should have_selector("input", :name=>"board_location[locality]")
      form.should have_selector("input", :name=>"board_location[region]")
      form.should have_selector("input", :name=>"board_location[postal_code]")
      form.should have_selector("input", :name=>"board_location[country]")
      form.should have_selector("input[type=submit]") 
    end
  end
    
    it "should have a link to use an existing address when creating a new board if current_user has locations" 
    
    it "should not have a link to use an existing address when creating a new board if current_user does not have locations" 
    
  end