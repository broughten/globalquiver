class BoardSearchesController < ApplicationController
  def new
    @board_search = BoardSearch.new
    @geocodes = get_search_geocodes_for_view
  end
  
  def create
    @board_search = BoardSearch.new(params[:board_search])
    if @board_search.save
      redirect_to board_search_path(@board_search)
    else
      @geocodes = get_search_geocodes_for_view
      render :action => 'new'
    end
  end
  
  def show
    @board_search = BoardSearch.find(params[:id])
    @found_boards = Board.all
  end
  
  private
  def get_search_geocodes_for_view
    Geocode.all
  end
end
