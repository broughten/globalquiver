# add all of the PluginMethods to the ActiveRecord::Base class as
# class level methods 
ActiveRecord::Base.extend ReservationCalendar::PluginMethods

# add all of the CalendarHelper methods as instance level methods.
ActionView::Base.send :include, ReservationCalendar::CalendarHelper
