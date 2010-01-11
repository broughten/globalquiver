module CalendarHelper
  def month_link(month_date)
    link_to(month_date.strftime("%B"), {:month => month_date.month, :year => month_date.year}, :class => 'month_link')
  end
  
  # custom options for this calendar
  def reservation_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :reservation_strips => @reservation_strips,
      :month_name_text => @shown_month.strftime("%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.last_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>"
    }
  end

  def reservation_calendar
    calendar reservation_calendar_opts do |reservation|
      %(<a href="/reservations/#{reservation.id}" title="#{h(reservation.calendar_strip_text)}">#{h(reservation.calendar_strip_text)}</a>)
    end
  end
end