class PostsController < ApplicationController
  before_filter :login_required, :except => [:index,:show]
  session :off, :only => [:index,:show]
  caches_page :index, :show  
  cache_sweeper :post_sweeper, :only => [:create,:update,:destroy]
  
  def index
    @posts = Post.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @posts }
      format.atom
      format.rss
    end
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @post }
    end
  end

  def new
    @post = Post.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @post }
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      @post.save!
      flash[:notice] = 'Post was successfully created.'
      format.html { redirect_to(@post) }
      format.xml  { render :xml => @post, :status => :created, :location => @post }
    end
  end

  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      @post.update_attributes!(params[:post])
      flash[:notice] = 'Post was successfully updated.'
      format.html { redirect_to(@post) }
      format.xml  { head :ok }
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
