class InvoicesController < ApplicationController

  before_filter :login_required
  
  #GET /invoices
  def index
    if(current_user.role?(:admin))
      @invoices = Invoice.all
    else
      @invoices = Invoice.for_user(current_user)
    end
  end

  # GET /invoices/1
  def show
   @invoice = Invoice.find(params[:id])
  end

end
