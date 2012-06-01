class AddBillNumberToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :bill_number, :string
  end
end