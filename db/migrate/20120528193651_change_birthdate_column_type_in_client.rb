class ChangeBirthdateColumnTypeInClient < ActiveRecord::Migration
  def up
    change_column :clients, :birthdate, :date
  end

  def down
    change_column :clients, :birthdate, :datetime
  end
end
