class PostSweeper < ActionController::Caching::Sweeper
  observe Post

  def after_save(post)
    expire_cache(post)
  end

  def after_destroy(post)
    expire_cache(post)
  end

  def expire_cache(post)
    expire_page root_path
    expire_page posts_path
    expire_page paginated_posts_path(:page => 1) # is this enough?
    expire_page post_path(post)
    expire_page permalink_path(post.permalink)
  end
end


