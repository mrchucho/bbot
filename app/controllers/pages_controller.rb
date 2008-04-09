class PagesController < ApplicationController
  caches_page :about, :contact, :projects
  
  def error
    render :action => '500', :status => 500
  end

  def not_found
    render :action => '404', :status => 404
  end

  def about; end
  def contact; end
  def projects; end
end
