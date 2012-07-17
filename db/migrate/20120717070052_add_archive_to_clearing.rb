class AddArchiveToClearing < ActiveRecord::Migration
  def change
    add_column :clearings, :archive, :boolean, default: false
  end
end
