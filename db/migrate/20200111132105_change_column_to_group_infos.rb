class ChangeColumnToGroupInfos < ActiveRecord::Migration[5.2]
  def change
    rename_column :group_infos, :member, :group_name
  end
end

