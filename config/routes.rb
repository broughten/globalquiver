ActionController::Routing::Routes.draw do |map|

  map.resources :board_searches

  map.resources :black_out_dates

  map.resources :board_locations

  map.resources :search_locations

  map.resources :reservations, :path_prefix => '/boards/:board_id'
  
  map.resources :styles

  map.resources :boards, :member => { :remap => :get }

  map.resources :users

  map.resource :session

  map.resources :pages

  map.resource :blog_theme

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.with_options :controller => 'sessions'  do |m|
    m.login  '/login',  :action => 'new'
    m.logout '/logout', :action => 'destroy'
  end
  
  map.root :controller => 'pages', :action => 'show', :id => 'home'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
