require 'spec_helper'

describe LocationsController do
  integrate_views

  #Delete these examples and add some real ones
  it "should use LocationsController" do
    controller.should be_an_instance_of(LocationsController)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end
    
    describe "GET /location/new" do
      it "should assign needed variables for view" do
        get "new"
        assigns[:new_location].should_not be_nil
        assigns[:existing_locations].should_not be_nil
        assigns[:map].should_not be_nil
      end
      
      it "should initialize the @map instance" do
        GMap.any_instance.expects(:control_init).with(:large_map => true,:map_type => false)
        GMap.any_instance.expects(:center_zoom_init)
        get "new"
      end
    end

  end

  describe "anonymous user" do
    it_should_require_authentication_for_actions :new, :create
  end

end
