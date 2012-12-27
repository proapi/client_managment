class CreateEnclosures < ActiveRecord::Migration
  def change
    create_table :enclosures do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.integer :clearing_id
      t.attachment :attachment

      t.timestamps
    end
  end
end
