ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource :session
  map.resources :posts
  
  map.root :controller => 'posts'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
