class CreateClearings < ActiveRecord::Migration
  def change
    create_table :clearings do |t|
      t.references :client
      t.references :country
      t.string :tax_number
      t.string :year
      t.date :application_date
      t.string :commission_percent
      t.decimal :commission_min
      t.decimal :commission_currency
      t.decimal :rebate_calc
      t.date :office_send_date
      t.decimal :rebate_final
      t.date :decision_date
      t.decimal :commission_final
      t.date :commission_date
      t.decimal :exchange_rate
      t.date :maturity_date
      t.date :payment_date
      t.string :account_number
      t.text :description

      t.timestamps
    end
    add_index :clearings, :client_id
    add_index :clearings, :country_id
  end
end
