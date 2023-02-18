class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :item_name, null: false
      t.string :purchased_at, null: false
      t.string :produced_by, null: false
      t.text :review, null: false
      t.float :rate, null: false
      t.timestamps
    end
  end
end
