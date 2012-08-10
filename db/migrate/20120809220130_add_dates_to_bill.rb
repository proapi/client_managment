class AddDatesToBill < ActiveRecord::Migration
  def change
    add_column :bills, :issue_date, :date
    remove_column :bills, :payment_date
    add_column :clearings, :payment_date, :date
  end
end
