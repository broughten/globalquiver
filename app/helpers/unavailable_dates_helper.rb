module UnavailableDatesHelper
  def actual_dates(unavailable_dates)
    dates = []
    unavailable_dates.each do |date|
      dates.push(date.date.strftime("%m/%d/%Y"))
    end
    dates
  end


  def taken_dates_json
    if (@board.reserved_dates.blank?)
      return 'null'
    else
      takens = @board.reserved_dates.not_created_by(current_user).active
      takens.to_json
    end
  end

  def black_out_dates_json
    if (@board.black_out_dates.blank?)
      return 'null'
    else
      black_outs = @board.black_out_dates.not_created_by(current_user).active
      black_outs.to_json
    end
  end

  def owner_dates_json
    if (@board.black_out_dates.blank?)
      return 'null'
    else
      black_outs = @board.black_out_dates.created_by(current_user).active
      black_outs.to_json
    end
  end

  def reserved_dates_json
    if (@board.reserved_dates.blank?)
      return 'null'
    else
      reservations = @board.reserved_dates.created_by(current_user).active
      reservations.to_json
    end   
  end

  def days_until_next_reservation
    next_day_i_reserve_someone_elses_board = UnavailableDate.find(:first, :joins => :board, :order => "date", :conditions => ["date > ? AND unavailable_dates.creator_id = ? AND boards.creator_id != ?", Date.today, current_user.id, current_user.id])
    next_day_one_of_my_boards_is_reserved = UnavailableDate.find(:first, :joins => :board, :order => "date", :conditions => ["date > ? AND unavailable_dates.creator_id != ? AND boards.creator_id =?", Date.today, current_user.id, current_user.id])

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
end
