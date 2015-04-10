class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :description
      t.text :content
      t.integer :person_id

      t.timestamps null: false
    end
  end
end
