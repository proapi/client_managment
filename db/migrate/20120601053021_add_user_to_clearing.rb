class AddUserToClearing < ActiveRecord::Migration
  def change
    add_column :clearings, :user_id, :integer
  end
end
