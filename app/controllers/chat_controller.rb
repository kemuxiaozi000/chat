class ChatController < ApplicationController
  before_action :authenticate_user!, :only => [:index, :show, :new]

  def index

  end

  def show

  end

  # 加载个人数据（左上角）头像，昵称 add channel_id
  # timing 登陆就加载
  # in params[:user_id]
  # out {photo:"", name:""}
  def self_info
    user = UserManagement.find_by_user_id(current_user.id)
    res_tmp = {}
    res = []
    channel_ids_and_notename = []

    # 需要监听的channel 取得，包括交谈的备注名和uid
    user_relation = UserRelation.where(user_id_1: current_user.id)
    for item in user_relation
      tmp = {}
      tmp_user = NameNote.where('name_notes.user_id = ? and name_notes.noted_id = ? ', current_user.id, item.user_id_2)[0]
      tmp_photo = UserManagement.find_by_user_id(item.user_id_2)
      tmp_photo.present? ? tmp["photo"] = tmp_photo.photo : tmp["photo"] = ""
      tmp_user.present? ? tmp["name"] = tmp_user.note_name : tmp["name"] = User.find_by_id(item.user_id_2).nickname
      tmp["channel_id"] = item.channel_id
      tmp["target_user_id"] = item.user_id_2
      channel_ids_and_notename.push(tmp)
    end
    res_tmp["channel"] = channel_ids_and_notename

    # 个人信息
    res_tmp["email"] = current_user.email
    if user.present?
      res_tmp["nickname"] = current_user.nickname
      res_tmp["photo"] = user.photo.present? ?  user.photo : ""
      res_tmp["tel"] = user.phone.present? ?  user.phone : ""
      res_tmp["sex"] = user.sex.present? ?  user.sex : ""
      res_tmp["birthday"] = user.date_of_birth.present? ?  user.date_of_birth : ""
    else
      res_tmp["nickname"] = current_user.nickname
      res_tmp["photo"] = ""
      res_tmp["tel"] = ""
      res_tmp["sex"] = ""
      res_tmp["birthday"] = ""
    end
    res.push(res_tmp)
    render json: res
  end

  # 模糊查找好友nickname和备注 OR 所在的群的群名或者群成员nickname和备注
  # timing 查找框检测到输入
  # in params[:keyword] params[:user_id]
  # out {["user_list":{{user_note_name:"",photo:""}...],
  #      ["group_list":{group_note_name:"",photo:""}..] }
  def search_user
    # 根据自己的user_id，查找自己好友或所属群的备注有相似的
    user_or_group_note = NameNote.where("name_notes.user_id = ? and name_notes.note_name like ?", params[:user_id], "%"+params[:keyword]+"%")
    # 根据自己的user_id, 查找关系为1(好友), nickname相似的
    user_nickname = UserManagement.joins('inner join user_relations on user_managements.user_id = user_relations.user_id_1').
                    where("user_managements.user_id = ? and user_relations.relation = ? and user_managements.nickname like ?", params[:user_id], "1", "%"+params[:keyword]+"%")
    arr_person_uid = []
    arr_group_uid = []
    # 按照noted_id把它区分个人和群，放到两个arr里
    for item in user_or_group_note
      if item.noted_id.to_s.start_with?(USR)
        if arr_person_uid.count(item.noted_id) == 0
          arr_person_uid.push(item.noted_id)
        end
      elsif item.noted_id.to_s.start_with?(GRP)
        if arr_group_uid.count(item.noted_id) == 0
          arr_group_uid.push(item.noted_id)
        end
      end
    end
    for item in user_nickname
      if arr_group_uid
        arr_person_uid.push(item.user_id)
      end
    end
    # tmp_user_notename = NameNote.where('name_notes.user_id = ? and name_notes.noted_id IN(?) ', params[:user_id], arr_person_uid).
    #                             order("name_notes.noted_id ASC")

    tmp_user = UserManagement.joins('inner join name_notes on user_managements.user_id = name_notes.noted_id').
                              where('name_notes.user_id = ? and user_managements.user_id IN(?) ', params[:user_id], arr_person_uid).
                              order("user_managements.user_id ASC")
    # TODO
    tmp_group = NameNote.where('name_notes.user_id = ? and name_notes.noted_id IN(?) ', params[:user_id], arr_group_uid).
                                  order("name_notes.noted_id ASC")
    res_user = []
    res_group = []
    res = {}
    for i in tmp_user
      hash = {}
      hash["user_note_name"] = i.note_name
      hash["photo"] = i.photo
      res_user.push(hash)
    end
    for i in tmp_group
      hash = {}
      hash["user_note_name"] = i.note_name
      hash["photo"] = ""
      res_group.push(hash)
    end
    res["user_list"] = res_user
    res["group_list"] = res_group
    render json: res
  end

  # 加载左下角个人聊天的群（包含信息）
  # timing 首次需要加载，有新的聊天需要局部刷新，(包括上下顺序调整)
  # in
  # out [{ name: "好友", msg_num: "4", latest_msg_brief: "王铭铭-换尿布...", latest_msg_time: "22:20" },
  #       { name: "Dota小分队", msg_num: "2", latest_msg_brief: "今晚干...", latest_msg_time: "08:10", is_block: "false" },
  #       { name: "电装", msg_num: "5", latest_msg_brief: "今天加班吗...", latest_msg_time: "21:20", is_block: "true" }
  #      ] 群没有自己修改的名称，个人可以
  def chat_brief

  end

  # 加载tab2 所有 个人(包含群),按字母排序
  # timing 点击tab2人物icon
  # in params[:user_id]
  # out [{name: "alex", photo: "xxx"}, {name: "阿三", photo: "xxx"},{name: "阿姨", photo: "xxx"}]
  # 做不到out [{ index: "a", personList: [{name: "alex"}, {name: "阿三"},{name: "阿姨"}] },
      # { index: "b", personList: [{name: "bsa",uid:"USRxxx1"},{name: "bzng",uid:"USERxxxx"},{name: "帮厨",uid:"USERxxxx"}] },
      # { index: "e", personList: [{name: "饿了吗",uid:"USRxxx2"},{name: "饿了吧",uid:"USERxxxx"}] },
      # { index: "s", personList: [{name: "sunke",uid:"USRxxxx"},{name: "孙中山",uid:"USERxxxx"},{name: "孙得好1",uid:"USERxxxx"},{name: "孙得好2",uid:"USERxxxx"},{name: "孙得好3",uid:"USERxxxx"}] }
      # ]
  def address_book
    p "address_book"
    res = []
    user_tmp = UserRelation.where('user_relations.relation = ? and user_relations.user_id_1 = ?', "1", current_user.id).
                            joins('left join users on user_relations.user_id_2 = users.id ').
                            joins('left join user_managements on user_relations.user_id_2 = user_managements.user_id ').
                            joins('left join name_notes on user_relations.user_id_2 = name_notes.noted_id').
                            select('users.id, users.nickname, user_managements.photo, name_notes.note_name')
    if user_tmp.present?
      for item in user_tmp
        hash = {}
        hash["uid"] = item.id
        hash["name"] = item.note_name.blank? ? item.nickname : item.note_name
        hash["photo"] = item.photo.blank? ? "" : item.photo
        res.push(hash)
      end
    end
    p "address_book2 "
    p res
    render json: res
  end

  # 指定个人或群的成员列表
  # timing 鼠标hover在聊天记录框上方群名或个人名字上
  # in params[:user_id] 自己
  #    params[:u_id] 群或个人
  # out [{note_name:"",photo:"",id:""}...]
  def member_info_brief
    res = []
    if params[:u_id].to_s.start_with?("GRP")
      members = GroupInfo.find_by_group_id(params[:u_id]).member_list
      arr_members = members.to_s.split(",")
      tmp_user = UserManagement.joins('inner join name_notes on user_managements.user_id = name_notes.noted_id').
                                select('user_managements.user_id,user_managements.photo, name_notes.note_name, name_notes.noted_id').
                                where('name_notes.user_id = ? and user_managements.user_id IN(?) ', params[:user_id], arr_members)
      self_info = UserManagement.find_by_user_id(params[:user_id])
      self_hash = {}
      self_hash["user_note_name"] = "我"
      self_hash["photo"] = self_info.photo
      res.push(self_hash)
    else
      tmp_user = UserManagement.joins('inner join name_notes on user_managements.user_id = name_notes.noted_id').
                                select('user_managements.user_id,user_managements.photo, name_notes.note_name, name_notes.noted_id').
                                where('name_notes.user_id = ?  and user_managements.user_id = ? ', params[:user_id], params[:u_id])
    end
    for i in tmp_user
      hash = {}
      hash["user_note_name"] = i.note_name
      hash["photo"] = i.photo
      hash["noted_id"] = i.noted_id
      res.push(hash)
    end
    render json: res
  end

  # 聊天记录
  # timing 点击左下角列表个人聊天的群或个人，出现聊天记录
  # in params[:u_id] 群或个人
  # out [{memo_name:"",photo:""}...]
  def show_chat_record
    res = {}
    params[:user_id]
    params[:target_id]
    user_relation_1 = UserRelation.where('user_relations.user_id_1 = ? and user_relations.user_id_2 = ?', params[:user_id], params[:target_id])[0]
    user_relation_2 = UserRelation.where('user_relations.user_id_2 = ? and user_relations.user_id_1 = ?', params[:user_id], params[:target_id])[0]
    # channel_id在建立关系时已经产生，一定会有
    # if user_relation_1.channel_id.present?
    channel_id = user_relation_1.channel_id
    # else
    #   channel_id = PersonChatRecord.new.make_rc_uuid
    #   user_relation_1.update({'channel_id': channel_id})
    #   user_relation_2.update({'channel_id': channel_id})
    # end
    current_target = NameNote.where('name_notes.user_id = ? and name_notes.noted_id = ?', params[:user_id], params[:target_id])
    res[:channel_id] = channel_id
    res[:current_nickname] = current_target[0].note_name
    render json: res
  end

  # 发送消息 websocket  goeasy？
  # timing 点击右下角发送按钮
  # in params[:text]
  #     params[:target_id]
  #     params[:user_id]
  # out db 存
  def send_msg
    p "send_msg"
    if params[:target_id].to_s[0,3] == "USR"
      person_chat_uid = PersonChatRecord.new.make_rc_uuid
      PersonChatRecord.create(chat_content_id: person_chat_uid,
                              chat_content: params[:text],
                              user_id_1: params[:user_id],
                              user_id_2: params[:target_id],
                              # speak_time: null,
                              is_withdraw: 0,
                              is_seen: 0)
    elsif params[:target_id].to_s[0,3] == "GRP"
      group_chat_uid = GroupChatRecord.new.make_rc_uuid
      is_seen = ""
      # 取得群成员
      members = GroupInfo.find_by_group_id(params[:target_id]).member_list
      arr_members= members.to_s.split(",")
      # is_seen 作成1,0,0,0
      for item in arr_members
        if item == arr_members[0]
          if item == params[:user_id]
            is_seen += "1"
          elsif
            is_seen += "0"
          end
        elsif
          if item == params[:user_id]
            is_seen += ",1"
          elsif
            is_seen += ",0"
          end
        end
      end
      GroupChatRecord.create(chat_content_id: group_chat_uid,
                              content: params[:text],
                              group_id: params[:user_id],
                              user_id: params[:target_id],
                              # speak_time: null,
                              is_withdraw: 0,
                              is_seen: is_seen)
    end
  end

  def show_msg

  end

  # 将下线前的chat_preview的顺序以数组存入db
  def chat_preview

  end

  # 搜索匹配的用户
  def add_contact_search
    p "add_contact_search"
    res = []
    if params[:type] == "by_id"
      res_ele = {}
      user = User.find_by_id(params[:kw])
      user_manage = UserManagement.find_by_user_id(params[:kw])
      user_relation = UserRelation.where('user_relations.user_id_1 = ? and user_relations.user_id_2 = ?', current_user.id, params[:kw])
      if user_relation.present?
        res_ele["photo"] = user_manage.photo
      else
        res_ele["photo"] = ""
      end
      res_ele["nickname"] = user.nickname
      res_ele["user_id"] = user.id
      # 默认自己和自己是朋友
      if params[:kw].to_i == current_user.id
        res_ele["is_friend"] = true
      else
        user_relation = UserRelation.where('user_relations.user_id_1 = ? and user_relations.user_id_2 = ?', current_user.id, params[:kw])
        if user_relation.present? && (user_relation[0].relation == "1")
          res_ele["is_friend"] = true
        else
          res_ele["is_friend"] = false
        end
      end
      res.push(res_ele)
    elsif params[:type] == "by_name"
      users = User.joins('inner join user_managements on users.id = user_managements.user_id').
                select('users.id, users.nickname, user_managements.photo').
                where('users.nickname LIKE ? ', '%'+params[:kw]+'%')
      for item in users
        res_ele = {}
        # BUG 取不到怎么办
        res_ele["photo"] = item.photo
        res_ele["nickname"] = item.nickname
        res_ele["user_id"] = item.id
        # 默认自己和自己是朋友
        if item.id.to_i == current_user.id
          res_ele["is_friend"] = true
        else
          user_relation = UserRelation.where('user_relations.user_id_1 = ? and user_relations.user_id_2 = ?', current_user.id, item.id)
          if user_relation.present? && (user_relation[0].relation == "1")
            res_ele["is_friend"] = true
          else
            res_ele["is_friend"] = false
          end
        end
        res.push(res_ele)
      end
    end
    render json: res
  end

  # 添加好友
  def add_friend
    p "add_friend"
    channel = "|SERVER|"+ params[:add_user_id]
    # content format :  msg_content|msg_type|user_id
    content = "Request|AddFriend|" + current_user.id.to_s
    GoEasyClient.send(channel, content)
  end

  def find_user
    p "find_user"
    # 创建user_relation表
    user_tmp = User.find_by_id(params[:user_id])
    user_manage_tmp = UserManagement.find_by_user_id(params[:user_id])
    user_manage_tmp.present? ? user_photo = user_manage_tmp.photo : user_photo = ""
    # 查创建的channel,如果能查到，说明已经是好友了
    user_relation = UserRelation.where('user_relations.user_id_1 = ? and user_relations.user_id_2 = ?', current_user.id, params[:user_id])
    channel = user_relation.present? ? user_relation[0].channel_id : ""
    res = {
      "photo": user_photo,
      "nickname": user_tmp.nickname,
      "channel": channel,
    }
    render json: res
  end

  def add_friend_ignore
    p "add_friend_ignore"
    channel = "|SERVER|"+ params[:user_id]
    content = "Refuse|AddFriend|" + current_user.id.to_s
    GoEasyClient.send(channel, content)
  end

  def add_friend_accept
    p "add_friend_accept"
    channel = "|SERVER|"+ params[:user_id]
    content = "Accept|AddFriend|" + current_user.id.to_s
    GoEasyClient.send(channel, content)
    # TODO 更新user_relation表
    channel_id = PersonChatRecord.new.make_rc_uuid
    UserRelation.create!([{ user_id_1: current_user.id, user_id_2: params[:user_id], relation: '1', channel_id: channel_id },{  user_id_1: params[:user_id], user_id_2: current_user.id, relation: '1', channel_id: channel_id }])
    render json: {"channel": channel_id}
  end
end

require 'net/http'
class GoEasyClient
  def self.send(channel, content)
    Thread.new {
      Net::HTTP.post_form(URI("http://rest-hangzhou.goeasy.io/publish"),
      {appkey: "BC-242425a937724e418b4f51105a138e3b", channel: channel, content: content})
    }
  end
end
