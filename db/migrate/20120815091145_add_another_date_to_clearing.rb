class AddAnotherDateToClearing < ActiveRecord::Migration
  def change
    add_column :clearings, :internet_send_date, :date
    add_column :clearings, :commission_manual, :boolean
    add_column :bills, :total_manual, :boolean
  end
end
