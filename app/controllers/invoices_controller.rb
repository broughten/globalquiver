class InvoicesController < ApplicationController

  before_filter :login_required
  
  #GET /invoices
  def index
    @invoices = Invoice.for_user(current_user)
  end

  # GET /invoices/1
  def show
   @invoice = Invoice.find(params[:id])
  end

end
