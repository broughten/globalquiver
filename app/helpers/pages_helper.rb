module PagesHelper

  def most_popular_board
    #this query returns the active board with the most reserved dates (whether they are future or past)
    Board.find(:first,
      :select => 'count(*) as number, boards.*',
      :joins => "inner join reservations r on boards.id = r.board_id inner join unavailable_dates ud on ud.parent_id = r.id inner join images i on i.owner_id = boards.id",
      :conditions => "boards.inactive = false and ud.parent_type = 'Reservation' and i.owner_type = 'Board'",
      :group => 'boards.id',
      :order => 'number desc'
    )
  end

  def most_recent_shop
    #this query just returns the shop with the most recent created date.
    Shop.find(:first, :order => 'created_at desc')
  end
end
