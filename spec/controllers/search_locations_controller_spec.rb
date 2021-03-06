require 'spec_helper'

describe SearchLocationsController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views

  #Delete these examples and add some real ones
  it "should use SearchLocationsController" do
    controller.should be_an_instance_of(SearchLocationsController)
  end

  describe "admin user" do
    before(:each) do
      login_as_admin
    end

    it "should show the index template on index" do
      get :index
      flash[:notice].should be_nil
      response.should render_template("index")
    end

    it "should redirect to index with flash notic on successful create" do
      SearchLocation.any_instance.stubs(:save).returns(true)
      post :create
      flash[:notice].should_not be_nil
      response.should redirect_to(search_locations_path)
    end

    it "should render the new template with flash error on unsuccessful create" do
      SearchLocation.any_instance.stubs(:save).returns(false)
      post 'create'
      assigns[:search_location].should be_new_record
      flash[:error].should_not be_nil
      response.should render_template("new")
    end

    it "should redirect to index with flash notice on successful destroy" do
      SearchLocation.any_instance.stubs(:destroy).returns(true)
      put :destroy, :id => SearchLocation.make().id
      flash[:notice].should_not be_nil
      response.should redirect_to(search_locations_path)
    end

    it "should render the index template with flash error on unsuccessful destroy" do
      SearchLocation.any_instance.stubs(:destroy).returns(false)
      put :destroy, :id => SearchLocation.make().id
      flash[:error].should_not be_nil
      response.should redirect_to(search_locations_path)
    end

  end
  
  describe "non admin user" do
    before(:each) do
      login_as_user
    end
    
    it_should_require_admin_for_actions :index, :create, :new, :destroy
  end
end