class CommentsController < ApplicationController
  before_filter :login_required, :except => :create
  before_filter :find_post
  before_filter :find_comment, :only => [:show,:edit,:update,:destroy,:moderate]
  before_filter :restrict_closed_posts, :only => [:create,:update]
  session :off => false, :except => [:index,:show,:new,:create]
  cache_sweeper :post_sweeper, :only => [:create,:update,:destroy,:moderate]

  def index
    @comments = @post.comments.find(:all)
    respond_to do |format|
      format.html
      # format.xml  { render :xml => @comments }
    end
  end

  def show
    respond_to do |format|
      format.html 
      # format.xml  { render :xml => @comment }
    end
  end

  def new
    @comment = @post.comments.build
    respond_to do |format|
      format.html
      # format.xml  { render :xml => @comment }
    end
  end

  def edit
  end

  def create
    @comment = @post.comments.build(params[:comment])
    respond_to do |format|
      begin
        @comment.save!
        format.html { redirect_to permalink_path(@post.permalink) }
        # format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      rescue ActiveRecord::RecordInvalid 
        format.html { render :action => 'warning' }
      end
    end
  end

  def update
    respond_to do |format|
      @comment.update_attributes!(params[:comment])
      format.html { redirect_to post_comment_url(@post,@comment) }
      # format.xml  { head :ok }
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to(post_comments_url(@post)) }
      # format.xml  { head :ok }
    end
  end

  def moderate
    @comment.moderate
    respond_to do |format|
      format.html { redirect_to(post_comments_url(@post)) }
      # format.xml  { head :ok }
    end
  end

private
  def find_post
    @post = Post.find(params[:post_id])
  end
  def find_comment
    @comment = @post.comments.find(params[:id])
  end
  def restrict_closed_posts
    head(:forbidden) if @post.closed?
  end
end
