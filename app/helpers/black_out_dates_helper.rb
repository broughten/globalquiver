module BlackOutDatesHelper
  def actual_dates(unavailable_dates)
    dates = []
    unavailable_dates.each do |date|
      dates.push(date.date.strftime("%m/%d/%Y"))
    end
    dates
  end
end
