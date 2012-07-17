class ChangeAllDecimalColumns < ActiveRecord::Migration
  def change
    change_column :bills, :commission_final, :decimal, {:precision => 6, :scale => 2}
    change_column :bills, :exchange_rate, :decimal, {:precision => 6, :scale => 2}
    change_column :clearings, :commission_min, :decimal, {:precision => 6, :scale => 2}
    change_column :clearings, :commission_percent, :integer
    change_column :clearings, :rebate_calc, :decimal, {:precision => 6, :scale => 2}
    change_column :clearings, :rebate_final, :decimal, {:precision => 6, :scale => 2}
  end
end
