class DraftsController < ApplicationController
  before_filter :login_required
  def index
    @posts = Post.unpublished.by_oldest_first.find(:all)
  end
end
