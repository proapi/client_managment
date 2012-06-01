class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :short
      t.references :address
      t.string :tax_number

      t.timestamps
    end
    add_index :companies, :address_id
  end
end
