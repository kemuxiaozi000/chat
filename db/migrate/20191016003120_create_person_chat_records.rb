class CreatePersonChatRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :person_chat_records do |t|
      t.string :chat_content_id, comment: '内容id'
      t.string :chat_content, comment: '内容(图片保存为base64,)'
      t.string :user_id_1, comment: '用户1(发言人)'
      t.string :user_id_2, comment: '用户2(接收人)'
      t.string :speak_time, comment: '发言时间'
      t.string :is_withdraw, comment: '撤回状态 默认：0 撤回：1'
      t.string :is_seen, comment: '接收人查看状态 默认：0 已读：1'
      t.timestamps
    end
  end
end
