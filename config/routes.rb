ActionController::Routing::Routes.draw do |map|
  map.connect '/shop_calendar/:year/:month', :controller => 'calendar', :action => 'shop_calendar', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.connect '/trip_calendar/:year/:month', :controller => 'calendar', :action => 'trip_calendar', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.trip_calendar 'trip_calendar', :controller => 'calendar', :action => 'trip_calendar', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.shop_calendar 'shop_calendar', :controller => 'calendar', :action => 'shop_calendar', :year => Time.zone.now.year, :month => Time.zone.now.month

  map.resources :board_searches

  map.resources :black_out_dates

  map.resources :board_locations

  map.resources :search_locations
  
  map.resources :styles

  #example of a nested route.  It is shallow so we can use /reservations
  map.resources :boards, :shallow => true do |board|
    board.resources :reservations
  end

  map.resources :users

  map.resource :session

  map.resources :pages

  map.resource :blog_theme

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.lost_password '/lost_password', :controller => 'users', :action => 'lost_password'
  map.reset_password 'reset_password/:reset_code', :controller => 'users', :action => 'reset_password'
  map.with_options :controller => 'sessions'  do |m|
    m.login  '/login',  :action => 'new'
    m.logout '/logout', :action => 'destroy'
  end
  
  map.root :controller => 'pages', :action => 'show', :id => 'home'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
