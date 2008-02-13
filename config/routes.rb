ActionController::Routing::Routes.draw do |map|
  map.resource :session
  map.resources :users
  map.paginated_posts '/posts/pages/:page', :controller => 'posts', :action => 'index'
  map.formatted_paginated_posts '/posts/pages/:page.:format', :controller => 'posts', :action => 'index'
  map.resources :posts do |posts|
    posts.resources :comments, :member => {:moderate => :put}
  end
  map.resources :drafts
  
  map.connect 'pages', :controller => 'pages'
  map.root :controller => 'posts'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
