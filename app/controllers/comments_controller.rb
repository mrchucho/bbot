class CommentsController < ApplicationController
  before_filter :login_required, :except => [:index,:show,:new,:create]
  before_filter :find_post
  before_filter :find_comment, :only => [:show,:edit,:update,:destroy]
  session :off => false, :except => [:index,:show,:new,:create]
  cache_sweeper :post_sweeper, :only => [:create,:update,:destroy]

  def index
    @comments = @post.comments.find(:all)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comments }
    end
  end

  def show
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @comment }
    end
  end

  def new
    @comment = @post.comments.build
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comment }
    end
  end

  def edit
  end

  def create
    @comment = @post.comments.build(params[:comment])
    respond_to do |format|
      @comment.save!
      format.html { redirect_to post_comment_url(@post,@comment) }
      format.xml  { render :xml => @comment, :status => :created, :location => @comment }
    end
  end

  def update
    respond_to do |format|
      @comment.update_attributes!(params[:comment])
      format.html { redirect_to post_comment_url(@post,@comment) }
      format.xml  { head :ok }
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to(post_comments_url(@post)) }
      format.xml  { head :ok }
    end
  end

private
  def find_post
    @post = Post.find(params[:post_id])
  end
  def find_comment
    @comment = @post.comments.find(params[:id])
  end
end
