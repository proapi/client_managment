class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name

      t.timestamps
    end

    add_column :clearings, :agent_id, :integer, :not_null => true
    add_index :clearings, :agent_id
  end
end
