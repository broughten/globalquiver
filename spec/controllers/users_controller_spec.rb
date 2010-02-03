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
      login_as_surfer
    end
    
    it "should redirect to edit with a flash notice on successful update" do
      @user.stubs(:update_attributes).returns(true)
      post :update, {:id => @user.id, :surfer => {:first_name => 'James'}}
      flash[:notice].should_not be_nil
      response.should redirect_to(edit_user_path(:id => @user.id))
      
    end
    
    it "should render the edit page on unsucessful update" do
      @user.stubs(:update_attributes).returns(false)
      post :update, {:id => @user.id, :surfer => {:email => 'James'}}
      flash[:notice].should be_nil
      response.should render_template("edit")
    end

    it "should show an error when user attempts to upload a non-png or jpg image" do
      post :update, {:id => @user.id, :surfer => {:image_attributes => {:data => File.open(RAILS_ROOT + '/spec/fixtures/images/users/dummy.txt')}}}
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
      get "edit", :id => "1"
      response.should redirect_to(login_path)
    end
    
    it "should redirect to login screen on update" do
      put :update, :id => "1"
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

    describe "forgot password functionality" do
      it "should create an empty user on get" do
        get "lost_password"
        assigns[:user].should_not be_nil
      end

      it "should find the user by his email address on post" do
        user = Shop.make(:email =>"test@testing.com")
        post "lost_password", :user => user
        assigns[:user].should == user
      end

      it "should flash an error when it can't find the user" do
        post "lost_password", :user => User.new
        flash[:error].should == "Please enter a valid email address"
      end

      it "should try to create a reset code and redirect to root when it finds the user" do
        user = Shop.make(:email =>"test@testing.com")
        
        post "lost_password", :user => {:email =>"test@testing.com"}

        same_user_after_post = User.find_by_email("test@testing.com")
        same_user_after_post.password_reset_code.should_not be_nil
        flash[:notice].should == "Reset code sent to test@testing.com"
        response.should redirect_to(root_path)
      end
    end
    describe "reset password functionality" do
      it "should try to find user by password reset token" do
        user = Shop.make()
        user.create_password_reset_code
        post :reset_password, :reset_code => user.password_reset_code, :user => {:password => "whatev", :password_confirmation => "whatev"}
        assigns[:user].should == user
      end

      it "should flash an error and redirect to root path if the user isn't found" do
        user = Shop.make()
        post :reset_password, :reset_code => "wrong"
        flash[:error].should == "Reset password token invalid, please contact support."
        response.should redirect_to(root_path)
      end

      it "should modify the password and send a success message if it is able to change the password" do
        user = Shop.make(:email => "nada@test.com")
        user.create_password_reset_code
        current_crypted_password = user.crypted_password
        post :reset_password, :reset_code => user.password_reset_code, :user => {:password => "whatev", :password_confirmation => "whatev"}
        same_user_after_post = User.find_by_email("nada@test.com")
        same_user_after_post.crypted_password.should_not == current_crypted_password
        flash[:notice].should == "Password updated successfully for nada@test.com - You may now log in using your new password."
        response.should redirect_to(root_path)
      end

      it "should re-disply the password change page and not change the password if passwords don't match" do
        user = Shop.make(:email => "brudda@test.com")
        user.create_password_reset_code
        current_crypted_password = user.crypted_password
        post :reset_password, :reset_code => user.password_reset_code, :user => {:password => "whatev", :password_confirmation => "wrong"}
        same_user_after_post = User.find_by_email("brudda@test.com")
        same_user_after_post.crypted_password.should == current_crypted_password
        flash[:notice].should be_nil
        response.should render_template(:reset_password)
      end
    end
  end
end