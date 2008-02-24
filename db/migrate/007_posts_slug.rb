class PostsSlug < ActiveRecord::Migration
  def self.up
    add_column "posts","slug",:string
    Post.find(:all).each do |post|
      post.save
    end
  end

  def self.down
    remove_column "posts","slug"
  end
end
