class DraftsController < ApplicationController
  before_filter :login_required
  def index
    @posts = Post.find_unpublished(:all,:order => :created_at)
  end
end
