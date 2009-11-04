require 'spec_helper'

describe BoardLocationsController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views

  #Delete these examples and add some real ones
  it "should use BoardLocationsController" do
    controller.should be_an_instance_of(BoardLocationsController)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end 
    
    describe "GET /board_location/new" do
      it "should assign needed variables for view" do
        get "new"
        assigns[:board_location].should_not be_nil
        assigns[:existing_locations].should_not be_nil
        assigns[:map].should_not be_nil
      end
      
      it "should initialize the @map instance" do
        GMap.any_instance.expects(:control_init).with(:large_map => true,:map_type => false)
        GMap.any_instance.expects(:center_zoom_init)
        get "new"
      end
    end
    
    describe "POST /board_location (aka create location)" do
      it "should redirect to new board path with a flash message on successful save" do
        BoardLocation.any_instance.stubs(:valid?).returns(true)
        post 'create'
        assigns[:board_location].should_not be_new_record
        flash[:notice].should_not be_nil
        response.should redirect_to(new_board_path)
      end
      
      it "should redirect to new board path with a flash message and a unsaved new location if new location matches location in logged in user's locations" do
        location = mock()
        location.stubs(:matches?).returns(true)
        User.any_instance.stubs(:locations).returns([location])
        post 'create'
        assigns[:board_location].should be_new_record # because we should never get to the save
        flash[:notice].should_not be_nil
        response.should redirect_to(new_board_path)
      end
      
      it "should render new template with an error message on unsuccessful save" do
        BoardLocation.any_instance.stubs(:valid?).returns(false)
        post 'create'
        assigns[:board_location].should be_new_record
        flash[:error].should_not be_nil
        response.should render_template('new')
      end
      
      it "should pass parameters to new location" do
        post "create", :board_location =>{:country =>"USA"}
        assigns[:board_location].country.should == "USA"
      end
    end

  end

  describe "anonymous user" do
    it_should_require_authentication_for_actions :new, :create
  end

end