class DeleteAllMessages < ActiveRecord::Migration
  def up
    Message.delete_all
  end

  def down
    Message.delete_all
  end
end
