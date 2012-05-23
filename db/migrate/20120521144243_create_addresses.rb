class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :code
      t.string :city
      t.references :client
      t.string :kind

      t.timestamps
    end
    add_index :addresses, :client_id
  end
end
