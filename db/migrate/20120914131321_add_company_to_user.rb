class AddCompanyToUser < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer, default: 1
  end
end