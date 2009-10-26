
  require 'deadweight'


Deadweight::RakeTask.new do |dw|
  dw.stylesheets = ["/stylesheets/main.css", "/stylesheets/authentication.css", 
                    "/stylesheets/availability.css", "/stylesheets/board.css",
                    "/stylesheets/overview.css", "/stylesheets/shop.css",
                    "/stylesheets/style.css", "/stylesheets/user.css"]
  dw.pages = ["/", "/locations", "/boards/new", "/overview", 
              "/users/new", "/session/new", "/boards",
              "/pages/how", "/pages/why" ]
  dw.ignore_selectors = /flash|multimonth|errorExplanation|dp-|jCalendar/
end
