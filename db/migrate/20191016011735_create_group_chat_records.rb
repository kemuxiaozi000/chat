class CreateGroupChatRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :group_chat_records do |t|
      t.string :chat_content_id
      t.string :content, comment: '内容(图片保存为base64,)'
      t.string :group_id, comment: '群id'
      t.string :user_id, comment: '发言人'
      t.string :speak_time, comment: '发言时间'
      t.string :is_withdraw, comment: '发言状态 默认0 撤回：1'
      t.string :is_seen, comment: '已读状态 默认：0 已读：1   1,0,0,0,'
      t.timestamps
    end
  end
end
