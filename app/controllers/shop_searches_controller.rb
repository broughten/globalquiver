class ShopSearchesController < ApplicationController
  def new
    @shop_search = ShopSearch.new
    @search_locations = get_search_locations_for_view
  end
  
  def create
    @shop_search = ShopSearch.new(params[:shop_search])

    respond_to do |format|
      if @shop_search.save
        @found_shops = @shop_search.execute
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
