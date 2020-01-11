class AddColumnToUserManagements < ActiveRecord::Migration[5.2]
  def change
    add_column :user_managements, :chat_preview ,:string
  end
end
