require File.dirname(__FILE__) + '/../spec_helper'
 
describe SurferSearchesController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views
  
  describe "authenticated user" do
    before(:each) do
      login_as_user
    end
    
    describe "new action" do
      it "should assign a new SurferSearch model for the view " do
        get "new"
        assigns[:surfer_search].should be_new_record
      end
      it "should assign a collection of search locations for the view " do
        get "new"
        assigns[:search_locations].should_not be_nil
      end
    end
    
    describe "create action" do
      
      it "should pass parameters to surfer search" do
        xhr :post, :create, {:surfer_search =>{:location_id =>"1", :terms=>""}}
        assigns[:surfer_search].location_id.should == 1
      end
      
      it "should render the javascript on successful save" do
        SurferSearch.any_instance.stubs(:valid?).returns(true)
        xhr :post, :create, {:surfer_search =>{:location_id =>"", :terms=>""}}
        response.should render_template('create.js')
      end

      it "should execute the search on successful save" do
        SurferSearch.any_instance.stubs(:valid?).returns(true)
        SurferSearch.any_instance.expects(:execute).returns([])
        xhr :post, :create, {:surfer_search =>{:location_id =>"", :terms=>""}}
        response.should render_template('create.js')
      end
      
    end
  end
end
