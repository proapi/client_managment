class AddNumberManualToBill < ActiveRecord::Migration
  def change
    add_column :bills, :number_manual, :boolean, default: false
  end
end
