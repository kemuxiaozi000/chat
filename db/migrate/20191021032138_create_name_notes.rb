class CreateNameNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :name_notes do |t|
      t.string :user_id, comment: '用户'
      t.string :noted_id, comment: '被备注的用户或群'
      t.string :note_name, comment: '被备注的别名'
      t.timestamps
    end
  end
end
