module ReservationCalendar
  
  module PluginMethods
    def has_reservation_calendar
      # only include the methods once if has_reservation_calendar
      # is called more that once
      unless included_modules.include? InstanceMethods 
        extend ClassMethods 
        include InstanceMethods
      end
    end
    
    def acts_as_reserved_date
      include DateInstanceMethods
    end
  end

  # class Methods for the reservation class
  module ClassMethods
    # For the given month, find the start and end dates
    # Find all the reservations within this range, and create reservation strips for them
    def reservation_strips_for_month(shown_date, first_day_of_week=0)
      strip_start, strip_end = get_start_and_end_dates(shown_date, first_day_of_week)
      reservations = self.for_date_range(strip_start, strip_end)
      reservation_strips = create_reservation_strips(strip_start, strip_end, reservations)
      reservation_strips
    end
    
    # Expand start and end dates to show the previous month and next month's days,
    # that overlap with the shown months display
    def get_start_and_end_dates(shown_date, first_day_of_week=0)
      # start with the first day of the given month
      start_of_month = Date.civil(shown_date.year, shown_date.month, 1)
      # the end of last month
      strip_start = beginning_of_week(start_of_month, first_day_of_week)
      # the beginning of next month, unless this month ended evenly on the last day of the week
      if start_of_month.next_month == beginning_of_week(start_of_month.next_month, first_day_of_week)
        # last day of the month is also the last day of the week
        strip_end = start_of_month.next_month
      else
        # add the extra days from next month
        strip_end = beginning_of_week(start_of_month.next_month + 7, first_day_of_week)
      end
      [strip_start, strip_end]
    end
    
    # Create the various strips that show reservations
    def create_reservation_strips(strip_start, strip_end, reservations)
      # create an inital reservation strip, with a nil entry for every day of the displayed days
      reservation_strips = [[nil] * (strip_end - strip_start + 1)]

      #First I need to get rid of the dates that are outside my view.

      #Then I need to map each date to it's number on the array.

      reservations.each do |reservation|
        in_range_dates = reservation.reserved_dates.clip(strip_start, strip_end)

        range = []
        in_range_dates.each { |date_obj| range << (date_obj.date - strip_start).to_i }

        open_strip = space_in_current_strips?(reservation_strips, range)
          
        if open_strip.nil?
          # no strips open, make a new one
          new_strip = [nil] * (strip_end - strip_start + 1)
          range.each {|r| new_strip[r] = reservation}
          reservation_strips << new_strip
        else
          # found an open strip, add this reservation to it
          range.each {|r| open_strip[r] = reservation}
        end
      end
      reservation_strips
    end
    
    def space_in_current_strips?(reservation_strips, range)
      open_strip = nil
      for strip in reservation_strips
        strip_is_open = true
        range.each do |r|
          # overlapping reservations on this strip
          if !strip[r].nil?
            strip_is_open = false
            break
          end
        end

        if strip_is_open
          open_strip = strip
          break
        end
      end
      open_strip
    end
    
    def days_between(first, second)
      if first > second
        second + (7 - first)
      else
        second - first
      end
    end

    def beginning_of_week(date, start = 0)
      days_to_beg = days_between(start, date.wday)
      date - days_to_beg
    end
    
  end
  
  # Instance Methods for the reservation class
  module InstanceMethods
  
    def self.included(base)
      base.class_eval do
        named_scope :for_date_range, 
          lambda {|start_d, end_d| {:select => "DISTINCT #{name.underscore.pluralize}.*",
            :joins => :reserved_dates, 
            :conditions => [ "date >= ?  and date <= ?", start_d.to_time.utc, end_d.to_time.utc ]}}
      end
    end
  
    def color
      self[:color] || '#9aa4ad'
    end

    def color=(color)
      self[:color] = color
    end
  
    def days
      reserved_dates.size
    end
    
    def calendar_strip_text
      self[:name] || "Calendar Strip Text"
    end
  
  end
  
  # instance methods for the reserved date class
  module DateInstanceMethods
    def self.included(base)
      base.class_eval do
        named_scope :clip, 
          lambda { |start_date, end_date| {:conditions => ['date >= ? AND date <= ?', start_date, end_date] } }
      end
    end
  end
end