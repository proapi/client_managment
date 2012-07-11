class AddFieldsToBills < ActiveRecord::Migration
  def change
    add_column :bills, :user_id, :integer, not_null: true
    add_column :bills, :comment, :text
    add_index :bills, :user_id
  end
end
