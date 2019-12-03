class CreateGroupInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :group_infos do |t|
      t.string :group_id, comment: '群id'
      t.string :member_list, comment: '群成员 xx,xx2,xx3'
      t.string :group_creator, comment: '群主'
      t.string :create_date, comment: '创建时间'
      t.timestamps
    end
  end
end
