class AddAgentDateToClearing < ActiveRecord::Migration
  def change
    add_column :clearings, :agent_date, :date
  end
end
