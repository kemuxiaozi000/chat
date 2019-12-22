class AddColumnsToGroupInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :group_infos, :member, :string, comment: '成员个人'
  end
end
