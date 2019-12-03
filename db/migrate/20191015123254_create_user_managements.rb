class CreateUserManagements < ActiveRecord::Migration[5.2]
  def change
    create_table :user_managements do |t|
      t.string :user_id, comment: '用户id'
      t.string :nickname, comment: '昵称'
      t.string :name, comment: '姓名'
      t.string :sex, comment: '性别'
      t.string :password, comment: '密码'
      t.string :age, comment: '年龄'
      t.string :phone, comment: '手机'
      t.string :mail, comment: '邮箱'
      t.string :addr_province, comment: '所在地=省'
      t.string :addr_city, comment: '所在地=市'
      t.string :addr_district, comment: '所在地=区'
      t.string :addr_location, comment: '所在地=区'
      t.string :date_of_birth, comment: '生日'
      t.text :photo, limit: 4_294_967_295, comment: '照片'
      t.string :hobby, comment: '爱好'
      t.integer :activity, default: 0, comment: '活跃度'
      t.integer :lvl, default: 0, comment: '等级'
      t.string :current_state, comment: '当前状态 0: offline, 1:busy, 2:free'
      t.string :last_sign_in, comment: '上次登录'
      t.string :total_time, comment: '登陆总时长'
      t.string :date_of_sign_up, comment: '注册时间'
      t.timestamps
    end

    add_index :user_managements, :user_id
  end
end
