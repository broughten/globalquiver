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
      takens = @board.reserved_dates.find(:all, :conditions => ['creator_id != ?', current_user.id])
      takens.to_json
    end
  end

  def black_out_dates_json
    if (@board.black_out_dates.blank?)
      return 'null'
    else
      black_outs = @board.black_out_dates.find(:all, :conditions => ['creator_id != ?', current_user.id])
      black_outs.to_json
    end
  end

  def owner_dates_json
    if (@board.black_out_dates.blank?)
      return 'null'
    else
      black_outs = @board.black_out_dates.find(:all, :conditions => ['creator_id = ?', current_user.id])
      black_outs.to_json
    end
  end



  def reserved_dates_json
    if (@board.reserved_dates.blank?)
      return 'null'
    else
      reservations = @board.reserved_dates.find(:all, :conditions => ['creator_id = ?', current_user.id])
      reservations.to_json
    end   
  end
end
