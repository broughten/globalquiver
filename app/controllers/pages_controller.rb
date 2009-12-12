class PagesController < ApplicationController

  PAGE_KEYWORDS = %w(Home Blog About FAQ)

  helper_method :total_user_count, :recent_users, :total_board_count

  def show
    @title = "Global Quiver / #{params[:id]}"
    if (params[:id].downcase == 'home') && (logged_in?)
      render :template => "pages/overview"
    else
      render :template => current_page
    end
  end

  protected

  def current_page
    "pages/#{params[:id].to_s.downcase}"
  end

    def recent_users(n=3)
    User.latest.limited_to(n)
  end

  def total_user_count
    @total_user_count ||= User.count
  end
  
  def total_board_count
    @total_board_count ||= Board.count
  end

end

