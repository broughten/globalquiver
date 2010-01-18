require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views

  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end
  
  describe "for authenticated user" do
    before(:each) do
      login_as_user
    end
    
    it "should redirect to edit with a flash notice on successful update" do
      User.any_instance.stubs(:update_attributes).returns(true)
      post :update
      flash[:notice].should_not be_nil
      response.should redirect_to(edit_user_path(:id => @user.id))
      
    end
    
    it "should render the edit page on unsucessful update" do
      User.any_instance.stubs(:update_attributes).returns(false)
      post :update
      flash[:notice].should be_nil
      response.should render_template("edit")
    end

    describe "when showing user" do
      before(:each) do
        @temp_user = Surfer.make()
      end
      it "should attempt to find the surfer in question" do
        User.expects(:find).returns(@temp_user)
        get 'show', :id=>@temp_user.id
        assigns[:user].should == @temp_user
      end

      it "should render the show view" do
        get 'show', :id=>@temp_user.id
        response.should render_template("show")
      end
    end

  end
  
  describe "anonymous user" do
    it "should redirect to login screen on edit" do
      get :edit
      response.should redirect_to(login_path)
    end
    
    it "should redirect to login screen on update" do
      post :update
      response.should redirect_to(login_path)
    end

    it "should show the user on show" do
      get :show, :id=>Surfer.make.id
      response.should render_template("show")
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
end