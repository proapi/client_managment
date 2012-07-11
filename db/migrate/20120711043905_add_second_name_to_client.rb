class AddSecondNameToClient < ActiveRecord::Migration
  def change
    add_column :clients, :middlename, :string
  end
end
