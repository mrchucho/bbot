ActionController::Routing::Routes.draw do |map|
  map.resource :session
  map.resources :users
  map.resources :drafts
  map.resources :moderations
  map.resources :pages

  map.with_options :controller => 'posts',:action => 'index' do |page|
    page.paginated_posts '/posts/pages/:page'
    page.formatted_paginated_posts '/posts/pages/:page.:format'
  end

  map.permalink ':year/:month/:day/:slug', :controller => 'posts', :action => 'show', :conditions => {:method => :get} 
  map.resources :posts do |post|
    post.resource :comments, :path_prefix => ':year/:month/:day/:slug'
  end

  map.root :controller => 'posts'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
