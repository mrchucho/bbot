class PostsModeratedCommentsCount < ActiveRecord::Migration
  def self.up
    add_column "posts","moderated_comments_count",:integer,:default => 0
  end

  def self.down
    remove_column "posts","moderated_comments_count"
  end
end
