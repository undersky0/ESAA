class DropBookTable < ActiveRecord::Migration
  def up
    drop_table :books
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
