module ReservationsHelper
  def days_until_next_reservation
    next_day_i_reserve_someone_elses_board = UnavailableDate.find(:first, :joins => "inner join reservations on parent_id = reservations.id", :order => "date", :conditions => ["parent_type = 'Reservation' AND date > ? AND reservations.creator_id = ? AND reservations.deleted_at is null", Date.today, current_user.id])
    next_day_one_of_my_boards_is_reserved = UnavailableDate.find(:first, :joins => "inner join reservations on parent_id = reservations.id inner join boards on reservations.board_id = boards.id", :order => "date", :conditions => ["date > ? AND reservations.creator_id != ? AND boards.creator_id =?", Date.today, current_user.id, current_user.id])
    days_until_theirs = next_day_i_reserve_someone_elses_board.date - Date.today unless next_day_i_reserve_someone_elses_board.nil?
    days_until_mine = next_day_one_of_my_boards_is_reserved.date - Date.today unless next_day_one_of_my_boards_is_reserved.nil?
     
    if (days_until_theirs.nil? && !days_until_mine.nil?)
     return days_until_mine
    end
    if (days_until_mine.nil? && !days_until_theirs.nil?)
     return days_until_theirs
    end
    if (days_until_mine.nil? && days_until_theirs.nil?)
     return -1
    end

    (days_until_theirs > days_until_mine) ? days_until_mine : days_until_theirs

  end

  def next_reservation
    next_day_i_reserve_someone_elses_board = UnavailableDate.find(:first, :joins => "inner join reservations on parent_id = reservations.id", :order => "date", :conditions => ["parent_type = 'Reservation' AND date > ? AND reservations.creator_id = ? AND reservations.deleted_at is null", Date.today, current_user.id])
    next_day_one_of_my_boards_is_reserved = UnavailableDate.find(:first, :joins => "inner join reservations on parent_id = reservations.id inner join boards on reservations.board_id = boards.id", :order => "date", :conditions => ["date > ? AND reservations.creator_id != ? AND boards.creator_id =?", Date.today, current_user.id, current_user.id])
    if (next_day_i_reserve_someone_elses_board.nil? && !next_day_one_of_my_boards_is_reserved.nil?)
     return next_day_one_of_my_boards_is_reserved.parent
    end
    if (next_day_one_of_my_boards_is_reserved.nil? && !next_day_i_reserve_someone_elses_board.nil?)
     return next_day_i_reserve_someone_elses_board.parent
    end
    if (next_day_i_reserve_someone_elses_board.nil? && next_day_i_reserve_someone_elses_board.nil?)
     return nil
    end
    (next_day_i_reserve_someone_elses_board.date > next_day_one_of_my_boards_is_reserved.date) ? next_day_one_of_my_boards_is_reserved.parent : next_day_i_reserve_someone_elses_board.parent

  end
end
