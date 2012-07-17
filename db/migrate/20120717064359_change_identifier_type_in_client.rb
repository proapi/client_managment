class ChangeIdentifierTypeInClient < ActiveRecord::Migration
  def change
    change_column :clients, :identifier, :integer
  end
end
