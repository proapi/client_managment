class DeleteAllMessages < ActiveRecord::Migration
  Message.delete_all
end
