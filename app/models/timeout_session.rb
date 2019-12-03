class TimeoutSession < ApplicationRecord
  # 事例初次查看
  def createtimeout_session(repair_case_id, user_id)
    timedate = Time.new.strftime('%Y/%m/%d %H:%M')
    TimeoutSession.create(user_id: user_id, repair_case_id: repair_case_id, open_time: timedate)
  end

  # 专家变更确认事例时间更新
  def updatetimeout_session(repair_case_id, user_id)
    timedate = Time.new.strftime('%Y/%m/%d %H:%M')
    TimeoutSession.where(repair_case_id: repair_case_id).find_each do |timeoutsession|
        timeoutsession.update_attributes(:user_id => user_id, :open_time => timedate)
    end
  end
end
