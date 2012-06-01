class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.references :clearing
      t.references :company

      t.timestamps
    end
    add_index :bills, :clearing_id
    add_index :bills, :company_id
  end
end
