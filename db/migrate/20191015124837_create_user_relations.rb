class CreateUserRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_relations do |t|
      t.string :user_id_1, comment: '用户1(发起添加好友的人)'
      t.string :user_id_2, comment: '用户2(接受添加好友的人)'
      t.string :relation,  comment: '关系值 1 为互为好友'
      t.timestamps
    end
  end
end
