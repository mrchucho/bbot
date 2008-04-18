class ModerationsController < ApplicationController
  before_filter :login_required
  before_filter :find_comment, :only => %w(show update destroy)
  cache_sweeper :post_sweeper, :only => %w(update destroy)

  def index
    @comments = Comment.find_unmoderated(:all,:include => :post)
  end

  def show
  end

  def update
    respond_to do |format|
      @comment.moderate
      format.html do
        post = @comment.post
        flash[:notice] = "Moderated comment by <em>#{@comment.author}</em> for post <a href=\"#{post_path(post)}\">#{post.title}</a>."
        redirect_to moderations_url 
      end
      format.js { head :ok }
    end
  end

  def destroy
    respond_to do |format|
      @comment.destroy
      format.html do
        post = @comment.post
        flash[:notice] = "Deleted comment by <em>#{@comment.author}</em> for post <a href=\"#{post_path(post)}\">#{post.title}</a>."
        redirect_to moderations_url 
      end
      format.js   { head :ok }
    end
  end
private
  def find_comment
    @comment = Comment.find_unmoderated(params[:id])
  end
end
