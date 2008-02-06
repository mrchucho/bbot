class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.string :category
      t.text :body
      t.text :body_raw

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
