class PagesController < ApplicationController
  before_filter :login_required, :except => [:index,:show]
  before_filter :find_page, :only => %w(show edit update destroy)
  caches_page :index, :show
  cache_sweeper :page_sweeper, :only => %w(create update destroy)

  def index
    @pages = Page.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  def show
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @page }
    end
  end

  def new
    @page = Page.new
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @page }
    end
  end

  def edit
  end

  def create
    @page = Page.new(params[:page])
    respond_to do |format|
      @page.save!
      format.html { redirect_to(page_path(@page.permalink)) }
      format.xml  { render :xml => @page, :status => :created, :location => @page }
    end
  end

  def update
    respond_to do |format|
      @page.update_attributes!(params[:page])
      format.html { redirect_to(page_path(@page.permalink)) }
      format.xml  { head :ok }
    end
  end

  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end

private
  def find_page
    @page = Page.find_by_title(params[:id])
  end
end
