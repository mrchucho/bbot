class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :post_id
      t.string :author
      t.string :author_email
      t.boolean :moderated, :default => false
      t.text :body
      t.text :body_raw

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
