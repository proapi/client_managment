class RemoveFieldsFromClearing < ActiveRecord::Migration
  def up
    remove_column :clearings, :commission_final
    remove_column :clearings, :commission_date
    remove_column :clearings, :exchange_rate
    remove_column :clearings, :maturity_date
    remove_column :clearings, :payment_date
    remove_column :clearings, :account_number
    add_column :bills, :commission_final, :decimal, precision:
    add_column :bills, :commission_date, :date
    add_column :bills, :exchange_rate, :decimal
    add_column :bills, :maturity_date, :date
    add_column :bills, :payment_date, :date
  end

  def down
    add_column :clearings, :commission_final, :decimal
    add_column :clearings, :commission_date, :date
    add_column :clearings, :exchange_rate, :decimal
    add_column :clearings, :maturity_date, :date
    add_column :clearings, :payment_date, :date
    add_column :clearings, :account_number, :string
    remove_column :bills, :commission_final
    remove_column :bills, :commission_date
    remove_column :bills, :exchange_rate
    remove_column :bills, :maturity_date
    remove_column :bills, :payment_date
  end
end
