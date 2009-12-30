class StylesController < ApplicationController
  before_filter :authorize

  # GET /styles
  def index
    @styles = Style.find(:all)
  end

  # GET /styles/new
  def new
    @style = Style.new
  end

  # POST /styles
  def create
    @style = Style.new(params[:style])

    respond_to do |format|
      if (@style.save)
        flash[:notice] = 'Style was successfully created.'
        format.html { redirect_to styles_path }
      else
        format.html do
          flash[:error] = 'Style was invalid. Please try again.'
          render :action => "new"
        end
      end
    end

  end

  def destroy
    @style = Style.find_by_id(params[:id])
    respond_to do |format|
      if @style.destroy
        format.html do
          flash[:notice] = 'Style deleted.'
          redirect_to styles_path
        end
      else
        format.html do
          flash[:error] = 'Unable to delete style.'
          redirect_to  styles_path
        end
      end
    end
  end
end
