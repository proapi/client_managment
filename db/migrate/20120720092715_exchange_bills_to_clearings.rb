class ExchangeBillsToClearings < ActiveRecord::Migration
  def up
    remove_column :bills, :exchange_rate
    add_column :clearings, :exchange_rate, :decimal, :precision => 8, :scale => 4

    remove_column :bills, :commission_date
    add_column :clearings, :commission_date, :date

    remove_column :bills, :commission_final
    add_column :clearings, :commission_final, :decimal, :precision => 6, :scale => 2

    add_column :bills, :total, :decimal, :precision => 6, :scale => 2

    add_column :clearings, :income_date, :date
    add_column :clearings, :income_total, :decimal, :precision => 6, :scale => 2
    add_column :clearings, :income_exchange_rate, :decimal, :precision => 8, :scale => 4
    add_column :clearings, :total_to_client, :decimal, :precision => 6, :scale => 2
  end

  def down
    remove_column :clearings, :exchange_rate
    add_column :bills, :exchange_rate, :decimal, :precision => 8, :scale => 4

    remove_column :clearings, :commission_date
    add_column :bills, :commission_date, :date

    remove_column :clearings, :commission_final
    add_column :bills, :commission_final, :decimal, :precision => 6, :scale => 2

    remove_column :bills, :total

    remove_column :clearings, :income_date
    remove_column :clearings, :income_total
    remove_column :clearings, :income_exchange_rate
    remove_column :clearings, :total_to_client
  end
end
