class ChangeRelationInMessages < ActiveRecord::Migration
  def up
    remove_index :messages, :client_id
    remove_column :messages, :client_id
    add_column :messages, :clearing_id, :integer
    add_index :messages, :clearing_id
  end

  def down
    remove_index :messages, :clearing_id
    remove_column :messages, :clearing_id
    add_column :messages, :client_id, :integer
    add_index :messages, :client_id
  end
end
