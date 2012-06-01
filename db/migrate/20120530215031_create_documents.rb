class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.text :body
      t.references :country

      t.timestamps
    end
    add_index :documents, :country_id
  end
end
