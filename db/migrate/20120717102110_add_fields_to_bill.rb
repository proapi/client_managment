class AddFieldsToBill < ActiveRecord::Migration
  def change
    add_column :bills, :payment_form, :string
    add_column :bills, :title, :string
    add_column :bills, :units, :string

    #remove_column :bills, :exchange_rate
    #add_column :clearing, :exchange_rate, :decimal, :precision => 6, :scale => 2
  end
end
