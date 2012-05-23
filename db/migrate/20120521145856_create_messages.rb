class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :source
      t.string :origin
      t.text :body
      t.references :user
      t.references :client

      t.timestamps
    end
    add_index :messages, :user_id
    add_index :messages, :client_id
  end
end
