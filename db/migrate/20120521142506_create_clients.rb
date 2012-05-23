class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :lastname
      t.string :firstname
      t.timestamp :birthdate
      t.string :telephone
      t.string :mobile
      t.string :email
      t.string :identifier
      t.text :description

      t.timestamps
    end
  end
end
