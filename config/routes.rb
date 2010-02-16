ActionController::Routing::Routes.draw do |map|
  map.connect '/shop_calendar/:year/:month', :controller => 'calendar', :action => 'shop_calendar', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.connect '/trip_calendar/:year/:month', :controller => 'calendar', :action => 'trip_calendar', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.trip_calendar 'trip_calendar', :controller => 'calendar', :action => 'trip_calendar', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.shop_calendar 'shop_calendar', :controller => 'calendar', :action => 'shop_calendar', :year => Time.zone.now.year, :month => Time.zone.now.month

  map.resources :shop_searches
  
  map.resources :surfer_searches

  map.resources :board_searches, :singular => "board_search"

  map.resources :comments

  map.connect 'boards/:id/new_comment', :controller => 'boards', :action => 'new_comment'
  
  map.new_location_for_board 'boards/:id/new_location_for_board', :controller => 'boards', :action => 'new_location_for_board'


  map.connect 'comments/:id/reply', :controller => 'comments', :action => 'reply'

  map.resources :black_out_dates

  map.resources :board_locations

  map.resources :search_locations
  
  map.resources :styles

  #example of a nested route.  It is shallow so we can use /reservations
  map.resources :boards, :shallow => true do |board|
    board.resources :reservations
  end

  map.resources :specific_boards

  map.resources :users

  map.resource :session

  map.resources :surfers

  map.resources :shops

  map.resources :pages

  map.resource :blog_theme

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.lost_password '/lost_password', :controller => 'users', :action => 'lost_password'
  map.connect 'reset_password/:reset_code', :controller => 'users', :action => 'reset_password'
  map.with_options :controller => 'sessions'  do |m|
    m.login  '/login',  :action => 'new'
    m.logout '/logout', :action => 'destroy'
  end
  
  map.root :controller => 'pages', :action => 'show', :id => 'home'
end
