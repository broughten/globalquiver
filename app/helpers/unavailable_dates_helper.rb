module UnavailableDatesHelper
  def actual_dates(unavailable_dates)
    dates = []
    unavailable_dates.each do |date|
      dates.push(date.date.strftime("%m/%d/%Y"))
    end
    dates
  end

  def black_out_dates_json_for(board)
    if (board.black_out_dates.blank?)
      return 'null'
    else
      black_outs = board.black_out_dates
      black_outs.to_json
    end
  end
  
  def reserved_dates_json_for(board)
    if (board.reserved_dates.blank? || board.is_generic?)
      return 'null'
    else
      reservations = board.reserved_dates
      reservations.to_json
    end   
  end
end
