require 'spec_helper'

describe LocationsController do
  #don't integrate views here as we'll separately test them.
  #integrate_views

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
    
    describe "POST /locations (aka create location)" do
      it "should redirect to new board path with a flash message on successful save" do
        Location.any_instance.stubs(:valid?).returns(true)
        post 'create'
        assigns[:location].should_not be_new_record
        flash[:notice].should_not be_nil
        response.should redirect_to(new_board_path)
      end

      it "should render new template without a flash message on unsuccessful save" do
        Location.any_instance.stubs(:valid?).returns(false)
        post 'create'
        assigns[:location].should be_new_record
        flash[:notice].should be_nil
        response.should render_template('new')
      end
      
      it "should pass parameters to new location" do
        post "create", :location =>{:country =>"USA"}
        assigns[:location].country.should == "USA"
      end
    end

  end

  describe "anonymous user" do
    it_should_require_authentication_for_actions :new, :create
  end

end
