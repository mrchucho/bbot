class PagesController < ApplicationController
  before_filter :login_required, :except => [:index,:show]
  before_filter :find_page, :only => %w(show edit update destroy)
  caches_page :index, :show
  cache_sweeper :page_sweeper, :only => %w(create update destroy)

  def index
    @pages = Page.find(:all)
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(params[:page])
    respond_to do |format|
      @page.save!
      format.html { redirect_to(page_path(@page.permalink)) }
    end
  end

  def update
    respond_to do |format|
      @page.update_attributes!(params[:page])
      format.html { redirect_to(page_path(@page.permalink)) }
    end
  end

  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to(pages_url) }
    end
  end

private
  def find_page
    @page = Page.find_by_title(params[:id])
  end
end
