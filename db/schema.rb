# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_05_031906) do

  create_table "group_chat_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "chat_content_id"
    t.string "content", comment: "内容(图片保存为base64,)"
    t.string "group_id", comment: "群id"
    t.string "user_id", comment: "发言人"
    t.string "speak_time", comment: "发言时间"
    t.string "is_withdraw", comment: "发言状态 默认0 撤回：1"
    t.string "is_seen", comment: "已读状态 默认：0 已读：1   1,0,0,0,"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "group_id", comment: "群id"
    t.string "member_list", comment: "群成员 xx,xx2,xx3"
    t.string "group_creator", comment: "群主"
    t.string "create_date", comment: "创建时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "name_notes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "user_id", comment: "用户"
    t.string "noted_id", comment: "被备注的用户或群"
    t.string "note_name", comment: "被备注的别名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_chat_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "chat_content_id", comment: "内容id"
    t.string "chat_content", comment: "内容(图片保存为base64,)"
    t.string "user_id_1", comment: "用户1(发言人)"
    t.string "user_id_2", comment: "用户2(接收人)"
    t.string "speak_time", comment: "发言时间"
    t.string "is_withdraw", comment: "撤回状态 默认：0 撤回：1"
    t.string "is_seen", comment: "接收人查看状态 默认：0 已读：1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
  end

  create_table "user_careers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "user_id", comment: "用户id"
    t.string "company", comment: "公司"
    t.string "company_tel", comment: "公司联系方式"
    t.string "department", comment: "部门"
    t.string "job", comment: "职位"
    t.string "industry", comment: "所属行业"
    t.string "entry_time", comment: "入职时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_careers_on_user_id"
  end

  create_table "user_managements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "user_id", comment: "用户id"
    t.string "nickname", comment: "昵称"
    t.string "name", comment: "姓名"
    t.string "sex", comment: "性别"
    t.string "password", comment: "密码"
    t.string "age", comment: "年龄"
    t.string "phone", comment: "手机"
    t.string "mail", comment: "邮箱"
    t.string "addr_province", comment: "所在地=省"
    t.string "addr_city", comment: "所在地=市"
    t.string "addr_district", comment: "所在地=区"
    t.string "addr_location", comment: "所在地=区"
    t.string "date_of_birth", comment: "生日"
    t.text "photo", limit: 4294967295, comment: "照片"
    t.string "hobby", comment: "爱好"
    t.integer "activity", default: 0, comment: "活跃度"
    t.integer "lvl", default: 0, comment: "等级"
    t.string "current_state", comment: "当前状态 0: offline, 1:busy, 2:free"
    t.string "last_sign_in", comment: "上次登录"
    t.string "total_time", comment: "登陆总时长"
    t.string "date_of_sign_up", comment: "注册时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_managements_on_user_id"
  end

  create_table "user_relations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "user_id_1", comment: "用户1(发起添加好友的人)"
    t.string "user_id_2", comment: "用户2(接受添加好友的人)"
    t.string "relation", comment: "关系值 1 为互为好友"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "channel_id", comment: "订阅号id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname", null: false, comment: "昵称"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
