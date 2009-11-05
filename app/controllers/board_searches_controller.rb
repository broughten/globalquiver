class BoardSearchesController < ApplicationController
  def new
    @board_search = BoardSearch.new
    @search_locations = get_search_locations_for_view
  end
  
  def create
    @board_search = BoardSearch.new(params[:board_search])
    if @board_search.save
      redirect_to board_search_path(@board_search)
    else
      @search_locations = get_search_locations_for_view
      render :action => 'new'
    end
  end
  
  def show
    @board_search = BoardSearch.find(params[:id])
    @found_boards = @board_search.execute
  end
  
  private
  def get_search_locations_for_view
    SearchLocation.all
  end
end
