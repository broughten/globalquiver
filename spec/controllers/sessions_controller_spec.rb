require 'spec_helper'

describe SessionsController do
   # make sure that the views actually get rendered instead of mocked
   # this will catch errors in the views.
   integrate_views
  it "should use SessionsController" do
    controller.should be_an_instance_of(SessionsController)
  end

  describe "POST create" do
    it "should authenticate a user with email and password" do
      # figure out what user method should get called
      User.expects(:authenticate).with("test@test.com", "password")
      post "create", :session=>{"email"=>"test@test.com", "password"=>"password"}
    end
    
    it "should assign the the current user" do
      controller.expects(:current_user=)
      post "create", :session=>{"email"=>"test@test.com", "password"=>"password"}
    end
    
    it "should redirect to the root path with a notice if successfully logged in" do
      controller.stubs(:logged_in?).returns(true)
      post "create", :session=>{"email"=>"test@test.com", "password"=>"password"}
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
    end
    
    it "should render the new action with a error if unsuccessfully logged in" do
      controller.stubs(:logged_in?).returns(false)
      post "create", :session=>{"email"=>"test@test.com", "password"=>"password"}
      response.should render_template("new")
      assigns[:error_messages].should_not be_nil
    end
  end
  
  describe "GET destroy" do
    before(:each) do
      login_as_user
    end
    it "should log the user out" do
      User.any_instance.expects(:forget_me)
      get "destroy"
    end
    
    it "should redirect to the root with a notice" do
      get "destroy"
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
    end
  end
end
