class AddToClientDateToClearing < ActiveRecord::Migration
  def change
    add_column :clearings, :to_client_date, :date
  end
end
