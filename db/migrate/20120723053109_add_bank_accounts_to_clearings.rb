class AddBankAccountsToClearings < ActiveRecord::Migration
  def change
    add_column :clearings, :bank_account_1, :string
    add_column :clearings, :bank_account_2, :string
    add_column :clearings, :bank_account_3, :string
    add_column :clearings, :bank_account, :text
    add_column :clearings, :on_clients_account, :boolean
  end
end
