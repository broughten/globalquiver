class SearchLocationsController < ApplicationController
  before_filter :authorize

  # GET /search_locations
  def index
    @search_locations = SearchLocation.find(:all)
  end

  # GET /search_locations/new
  def new
    @search_location = SearchLocation.new
  end

  # POST /search_locations
  def create
    @search_location = SearchLocation.new(params[:search_location])
        
    respond_to do |format|
      if (@search_location.save)
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to search_locations_path }
      else
        format.html do 
          flash[:error] = 'Location was invalid. Please try again.'
          render :action => "new" 
        end
      end
    end

  end

  def destroy
    @search_location = SearchLocation.find_by_id(params[:id])
    respond_to do |format|
      if @search_location.destroy
        format.html do
          flash[:notice] = 'Search Location deleted.'
          redirect_to search_locations_path
        end
      else
        format.html do
          flash[:error] = 'Unable to delete search location.'
          redirect_to  search_locations_path
        end
      end
    end
  end
end

