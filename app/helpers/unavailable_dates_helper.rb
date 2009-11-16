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
      takens = @board.reserved_dates.find(:all, :conditions => ['creator_id != ?', (current_user.nil?)?-1:current_user.id])
      takens.to_json
    end
  end

  def black_out_dates_json
    if (@board.black_out_dates.blank?)
      return 'null'
    else
      black_outs = @board.black_out_dates.find(:all, :conditions => ['creator_id != ?', (current_user.nil?)?-1:current_user.id])
      black_outs.to_json
    end
  end

  def owner_dates_json
    if (@board.black_out_dates.blank?)
      return 'null'
    else
      black_outs = @board.black_out_dates.find(:all, :conditions => ['creator_id = ?', (current_user.nil?)?-1:current_user.id])
      black_outs.to_json
    end
  end

  def reserved_dates_json
    if (@board.reserved_dates.blank?)
      return 'null'
    else
      reservations = @board.reserved_dates.find(:all, :conditions => ['creator_id = ?', (current_user.nil?)?-1:current_user.id])
      reservations.to_json
    end   
  end

  def days_until_next_reservation
    next_day_someone_reserves_my_board = UnavailableDate.find(:first, :joins => :board, :conditions => ["date > ? AND unavailable_dates.creator_id = ? AND boards.creator_id != ?", Date.today, current_user.id, current_user.id])
    next_day_one_of_my_boards_is_reserved = UnavailableDate.find(:first, :joins => :board, :conditions => ["date > ? AND unavailable_dates.creator_id != ? AND boards.creator_id =?", Date.today, current_user.id, current_user.id])
    
    days_until_theirs = next_day_someone_reserves_my_board.day - Date.today.day unless next_day_someone_reserves_my_board.nil?
    days_until_mine = next_day_one_of_my_boards_is_reserved.day - Date.today.day unless next_day_one_of_my_boards_is_reserved.nil?

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
