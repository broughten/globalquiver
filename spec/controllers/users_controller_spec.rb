require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  #Delete this example and add some real ones
  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end

  describe "creating a new user" do
    it "should create a new Shop instance if the is_shop param is yes" do
      post :create, :is_shop => 'yes'
      assigns[:user].class.should == Shop
    end

    it "should create a new Surfer instance if the is_shop parm is not set" do
      post :create
      assigns[:user].class.should == Surfer

    end
    it "should redirect to rool url with a flash message on successful save" do
      # since you don't pass in anything on the post you know what will
      # get created will be a surfer.  I couldn't figure out
      # how to attach the stub to the base class User
      Surfer.any_instance.stubs(:valid?).returns(true)
      post 'create'
      assigns[:user].should_not be_new_record
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end

    it "should render new template without a flash message on unsuccessful save" do
      Surfer.any_instance.stubs(:valid?).returns(false)
      post 'create'
      assigns[:user].should be_new_record
      flash[:notice].should be_nil
      response.should render_template('new')
    end

    it "should pass parameters to user" do
      post "create", :user =>{:email =>"test@testing.com"}
      assigns[:user].email.should == 'test@testing.com'
    end

  end

end