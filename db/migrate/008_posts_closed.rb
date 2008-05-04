class PostsClosed < ActiveRecord::Migration
  def self.up
    add_column "posts","closed",:boolean,:default => false
  end

  def self.down
    remove_column "posts","closed"
  end
end
