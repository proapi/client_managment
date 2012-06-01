class CreateAddressesCompaniesTable < ActiveRecord::Migration
  def up
    create_table(:addresses_companies, :id => false) do |t|
      t.integer :address_id
      t.integer :company_id
    end
    add_index :addresses_companies, :address_id
    add_index :addresses_companies, :company_id
  end

  def down
    drop_table :addresses_companies
    remove_index :addresses_companies, :address_id
    remove_index :addresses_companies, :company_id
  end
end
