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

      it "should find the specific board passed in if there was one" do
        board = SpecificBoard.make
        post "create", :board_location => {:region => "CA",
                                           :country => "USA",
                                           :postal_code => "93110",
                                           :street => "4426 Via Bendita",
                                           :locality => "Santa Barbara"},
                       :specific_board => {:id => board.id}
        assigns[:board].should == board
      end

      it "should find the generic board passed in if there was one" do
        board = GenericBoard.make
        post "create", :board_location => {:region => "CA",
                                           :country => "USA",
                                           :postal_code => "93110",
                                           :street => "4426 Via Bendita",
                                           :locality => "Santa Barbara"},
                       :generic_board => {:id => board.id}
        assigns[:board].should == board
      end

      it "should redirect to the generic board edit page if a new location is created for a generic board" do
        board = GenericBoard.make
        post "create", :board_location => {:region => "CA",
                                           :country => "USA",
                                           :postal_code => "93110",
                                           :street => "4426 Via Bendita",
                                           :locality => "Santa Barbara"},
                       :generic_board => {:id => board.id}
        response.should redirect_to(edit_generic_board_path(board))
      end

      it "should redirect to the specific board edit page if a new location is created for a specific board" do
        board = SpecificBoard.make
        post "create", :board_location => {:region => "CA",
                                           :country => "USA",
                                           :postal_code => "93110",
                                           :street => "4426 Via Bendita",
                                           :locality => "Santa Barbara"},
                       :specific_board => {:id => board.id}
        response.should redirect_to(edit_specific_board_path(board))
      end
    end

  end

  describe "anonymous user" do
    it "new action should require authentication" do
      get :new
      response.should redirect_to(login_path)
    end
    it "create action should require authentication" do
      post :create, :id => "1"
      response.should redirect_to(login_path)
    end
  end

end
