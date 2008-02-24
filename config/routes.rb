ActionController::Routing::Routes.draw do |map|
  map.resource :session
  map.resources :users
  
  # can paginated stuff go INSIDE posts and/or :member => {:pages => :get}
  map.paginated_posts '/posts/pages/:page', :controller => 'posts', :action => 'index'
  map.formatted_paginated_posts '/posts/pages/:page.:format', :controller => 'posts', :action => 'index'

  map.permalink ':year/:month/:day/:slug', :controller => 'posts', :action => 'show', :conditions => {:method => :get} 
  map.resources :posts do |post|
    post.resource :comments
  end
  map.resources :drafts
  
  map.pages 'pages', :controller => 'pages'
  map.root :controller => 'posts'

=begin
  map.with_options :controller => 'posts', :action => 'index' do |post|
    post.by_day   ':year/:month/:day', :conditions => {:method => :get} #, :requirements =>{ :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/}
    post.by_month ':year/:month', :conditions => {:method => :get} #, :requirements =>{:month => /\d{1,2}/, :day => /\d{1,2}/}
    post.by_year  ':year/', :conditions => {:method => :get} #, :requirements =>{:day => /\d{1,2}/}
  end
=end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
