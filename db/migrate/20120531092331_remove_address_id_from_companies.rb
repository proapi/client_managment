class RemoveAddressIdFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :address_id
  end

  def down
    add_column :companies, :address_id
  end
end
