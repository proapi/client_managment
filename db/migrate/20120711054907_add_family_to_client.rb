class AddFamilyToClient < ActiveRecord::Migration
  def change
    add_column :clients, :married, :integer
    add_column :clients, :married_date, :date
    add_column :clients, :married_data, :text
    add_column :clients, :children_data, :text
  end
end
