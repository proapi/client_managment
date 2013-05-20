class AddCurrencyToBills < ActiveRecord::Migration
  def change
    add_column :bills, :currency, :string, :default => 'PLN'
    Bill.reset_column_information
    Bill.all.each do |bill|
      bill.update_attributes!(:currency => 'PLN')
    end
  end
end
