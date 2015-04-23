class AddBookUploadToBook < ActiveRecord::Migration
  def change
    add_column :books, :attachment, :string
  end
end
