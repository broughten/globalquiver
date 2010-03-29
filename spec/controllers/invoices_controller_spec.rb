require 'spec_helper'

describe InvoicesController do
  # make sure that the views actually get rendered instead of mocked
  # this will catch errors in the views.
  integrate_views

  it "should use InvoicesController" do
    controller.should be_an_instance_of(InvoicesController)
  end

  describe "authenticated user" do
    before(:each) do
      login_as_user
    end
    
    describe "list invoices (GET /invoices)" do
      it "should grab the invoices associated with the logged in user" do
        invoice1 = Invoice.make(:responsible_user => @user)
        invoice2 = Invoice.make()
        
        get "index"
        
        assigns[:invoices].should include(invoice1)
        assigns[:invoices].should_not include(invoice2)
      end
      
      it "should render the index view" do
        get "index"
        response.should render_template("index")
      end
    end
    
    describe "show invoice (GET /invoices/1)" do
      before(:each) do
        @invoice = Invoice.make()
      end
      it "should attempt to find the board in question" do
        Invoice.expects(:find).returns(@invoice)
        get 'show', :id=>@invoice.id
        assigns[:invoice].should == @invoice
      end

      it "should render the show view" do
        get 'show', :id=>@invoice.id
        response.should render_template("show")
      end
    end

  end

  describe "anonymous user" do
    it "index action should require authentication" do
      get :index
      response.should redirect_to(login_path)
    end
    it "show action should require authentication" do
      invoice = Invoice.make()
      get :show, :id => invoice.id
      response.should redirect_to(login_path)
    end
  end

end
