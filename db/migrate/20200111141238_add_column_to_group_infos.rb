class AddColumnToGroupInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :group_infos, :member ,:string
  end
end
