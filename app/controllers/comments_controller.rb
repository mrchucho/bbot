class CommentsController < ApplicationController
  before_filter :login_required, :except => :create
  before_filter :find_post
  before_filter :find_comment, :only => [:show,:edit,:update,:destroy,:moderate]
  before_filter :protect_from_spam, :only => [:create,:update]
  before_filter :restrict_closed_posts, :only => [:create,:update]
  session :off => false, :except => [:index,:show,:new,:create]
  cache_sweeper :post_sweeper, :only => [:create,:update,:destroy,:moderate]

  def index
    @comments = @post.comments.find(:all)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html 
    end
  end

  def new
    @comment = @post.comments.build
    respond_to do |format|
      format.html
    end
  end

  def edit
  end

  def create
    @comment = @post.comments.build(params[:comment])
    respond_to do |format|
      @comment.save!
      flash[:notice] = "Your comment has been submitted and is awaiting moderation."
      format.html { redirect_to permalink_path(@post.permalink) }
    end
  end

  def update
    respond_to do |format|
      @comment.update_attributes!(params[:comment])
      format.html { redirect_to post_comment_url(@post,@comment) }
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to(post_comments_url(@post)) }
    end
  end
private
  def find_post
    @post = Post.find_by_permalink(params)
  end
  def find_comment
    @comment = @post.comments.find(params[:id])
  end
  def protect_from_spam
    head(:forbidden) unless params.key?(:_key) && params[:_key].blank?
  end
  def restrict_closed_posts
    head(:forbidden) if @post.closed?
  end
end
