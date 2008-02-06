ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource :session
  map.resources :posts do |posts|
    posts.resources :comments
  end
  
  map.root :controller => 'posts'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
