require 'spec_helper'

describe OverviewsController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views

  #Delete these examples and add some real ones
  it "should use OverviewsController" do
    controller.should be_an_instance_of(OverviewsController)
  end
  
  it "should respond to index events" do
    controller.should respond_to(:index)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end

    it "should redirect to index view" do
      get :index
      response.should render_template("index")
    end

  end

  describe "anonymous user" do
    it "should redirect to login page" do
      get :index
      response.should redirect_to(login_path)
    end
  end
end