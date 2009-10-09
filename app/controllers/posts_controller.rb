class PostsController < ApplicationController
  before_filter :login_required, :except => [:index,:show]
  before_filter :find_post, :only => [:show,:edit,:update,:destroy]
  caches_page :index
  cache_sweeper :post_sweeper, :only => [:create,:update,:destroy]
  
  def index
    @posts = Post.paginate_published(:all,:page => params[:page],:order => 'created_at desc')
    respond_to do |format|
      format.html
      format.xml  { render :xml => @posts }
      format.atom
      format.rss
    end
  end

  def show
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
  end

  def create
    @post = Post.new(params[:post])
    respond_to do |format|
      @post.save!
      format.html { redirect_to @post.published? ? permalink_path(@post.permalink) : drafts_path }
      format.xml  { render :xml => @post, :status => :created, :location => @post }
    end
  end

  def update
    respond_to do |format|
      @post.update_attributes!(params[:post])
      format.html { redirect_to @post.published? ? permalink_path(@post.permalink) : drafts_path }
      format.xml  { head :ok }
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end

private
  def find_post
    if params.key? :id
      @post = Post.find(params[:id])
    else
      @post = Post.find_by_permalink(params)
    end
  end
end
