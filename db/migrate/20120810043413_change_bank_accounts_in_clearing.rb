class ChangeBankAccountsInClearing < ActiveRecord::Migration
  def change
    remove_column :clearings, :bank_account_1
    remove_column :clearings, :bank_account_2
    remove_column :clearings, :bank_account_3
    remove_column :clearings, :bank_account
    remove_column :clearings, :on_clients_account
    add_column :clearings, :bank_account_number, :string
    add_column :clearings, :bank_account_data, :text
    add_column :clearings, :bank_account_destination, :string
  end
end
