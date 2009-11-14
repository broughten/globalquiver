require 'spec_helper'

describe PagesController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views

  #Delete these examples and add some real ones
  it "should use PagesController" do
    controller.should be_an_instance_of(PagesController)
  end
  
  it "should respond to show events" do
    controller.should respond_to(:show)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end

    it "should show overview page on root path for logged in user" do
      get "show", :id => 'home'
      response.should render_template("overview")
    end

  end

  describe "anonymous user" do
    it "should show home page on root path for anonymous user" do
      get "show", :id => 'home'
      response.should render_template("home")
    end
  end
end