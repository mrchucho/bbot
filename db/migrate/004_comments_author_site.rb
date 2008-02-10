class CommentsAuthorSite < ActiveRecord::Migration
  def self.up
    add_column "comments","author_site",:string
  end

  def self.down
    remove_column "comments","author_site"
  end
end
