class BoardSearchesController < ApplicationController
  def new
    @board_search = BoardSearch.new
  end
  
  def create
    @board_search = BoardSearch.new(params[:board_search])
    if @board_search.save
      redirect_to board_search_path(@board_search)
    else
      render :action => 'new'
    end
  end
  
  def show
    @board_search = BoardSearch.find(params[:id])
    @found_boards = Board.find(:all)
  end
end
