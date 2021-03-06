ActionController::Routing::Routes.draw do |map| 
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }

  map.connect ':controller/feed', :action => "feed"
  map.connect ':controller/for_feed', :action => "for_feed"

  # Restful Authentication Resources
  map.resources :users
  map.resources :passwords
  map.resource :session
  map.resources :patches

  map.connect 'patches/:id', :controller => 'patches',  :action => 'update', :requirements => { :method => :post }

  # Home Page
  map.root :controller => 'patches', :action => 'index'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
