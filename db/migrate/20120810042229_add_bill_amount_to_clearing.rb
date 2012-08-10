class AddBillAmountToClearing < ActiveRecord::Migration
  def change
    add_column :clearings, :bill_amount, :decimal, {:precision => 6, :scale => 2}
  end
end
