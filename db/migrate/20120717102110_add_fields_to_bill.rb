class AddFieldsToBill < ActiveRecord::Migration
  def change
    add_column :bills, :payment_form, :string
    add_column :bills, :title, :string
    add_column :bills, :units, :string
  end
end
