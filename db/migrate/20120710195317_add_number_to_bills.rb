class AddNumberToBills < ActiveRecord::Migration
  def change
    add_column :bills, :number, :string, unique: true, not_null: true
    add_index :bills, :number
  end
end
