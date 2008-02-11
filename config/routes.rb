ActionController::Routing::Routes.draw do |map|
  map.resource :session
  map.resources :users
  map.resources :posts do |posts|
    posts.resources :comments
  end
  map.resources :drafts
  
  map.connect 'pages', :controller => 'pages'
  map.root :controller => 'posts'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
