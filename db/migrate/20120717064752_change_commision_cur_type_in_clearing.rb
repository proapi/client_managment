class ChangeCommisionCurTypeInClearing < ActiveRecord::Migration
  def change
    change_column :clearings, :commission_currency, :string
  end
end
