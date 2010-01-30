class SurferSearchesController < ApplicationController

  before_filter :login_required

  def new
    @surfer_search = SurferSearch.new
    @search_locations = get_search_locations_for_view
  end
  
  def create
    @surfer_search = SurferSearch.new(params[:surfer_search])

    respond_to do |format|
      if @surfer_search.save
        @found_surfers = @surfer_search.execute
        format.js
      else
        @search_locations = get_search_locations_for_view
        render :action => 'new'
      end
    end
  end
  
  private
  def get_search_locations_for_view
    SearchLocation.all
  end
end
