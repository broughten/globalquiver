require 'spec_helper'

describe "/locations/new" do
  
  before(:each) do
    assigns[:location] = Location.make_unsaved()
    @existing_locations = mock()
    assigns[:existing_locations] = @existing_locations
    @existing_locations.stubs(:empty?).returns(true)
    map = mock()
    map.stubs(:div)
    map.stubs(:to_html)
    assigns[:map] = map
  end

  it "should have a form with text fields for the required fields" do
    render "locations/new.html.erb"
    response.should have_selector("form[method=post]", :action => locations_path) do |form|
      form.should have_selector("input", :name=>"location[street]")
      form.should have_selector("input", :name=>"location[locality]")
      form.should have_selector("input", :name=>"location[region]")
      form.should have_selector("input", :name=>"location[postal_code]")
      form.should have_selector("input", :name=>"location[country]")
      form.should have_selector("input[type=submit]") 
    end
  end
    
    it "should have a link to use an existing address when creating a new board if current_user has locations" 
    
    it "should not have a link to use an existing address when creating a new board if current_user does not have locations" 
    
  end