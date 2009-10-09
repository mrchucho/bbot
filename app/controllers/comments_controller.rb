class CommentsController < ApplicationController
  before_filter :find_post
  before_filter :protect_from_spam
  before_filter :restrict_closed_posts
  cache_sweeper :post_sweeper

  def create
    @comment = @post.comments.build(params[:comment])
    respond_to do |format|
      @comment.save!
      flash[:notice] = "Your comment has been submitted and is awaiting moderation."
      format.html { redirect_to permalink_path(@post.permalink) }
    end
  end

private
  def find_post
    @post = Post.find_by_permalink(params)
  end
  def protect_from_spam
    head(:forbidden) unless params.key?(:_key) && params[:_key].blank?
  end
  def restrict_closed_posts
    head(:forbidden) if @post.closed?
  end
end
