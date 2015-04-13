class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :title
      t.string :description
      t.text :content
      t.integer :book_id

      t.timestamps null: false
    end
  end
end
