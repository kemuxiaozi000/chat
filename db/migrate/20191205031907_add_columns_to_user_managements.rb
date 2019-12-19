class AddColumnsToUserManagements < ActiveRecord::Migration[5.2]
  def change
    add_column :user_managements, :avatar, :binary, comment: '头像1'
  end
end
