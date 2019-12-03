class CreateUserCareers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_careers do |t|
      t.string :user_id, comment: '用户id'
      t.string :company, comment: '公司'
      t.string :company_tel, comment: '公司联系方式'
      t.string :department, comment: '部门'
      t.string :job, comment: '职位'
      t.string :industry, comment: '所属行业'
      t.string :entry_time, comment: '入职时间'
      t.timestamps
    end
    add_index :user_careers, :user_id
  end
end
