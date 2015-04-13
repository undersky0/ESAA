class CreateBook < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :book_type
      t.boolean :fiction
      t.float :price
      t.integer :chapters_count
      t.integer :author_id
      t.date :published_at
      t.timestamps null: false

    end
  end
end
