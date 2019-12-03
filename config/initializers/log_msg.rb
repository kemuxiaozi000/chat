class LogMsg

  @@instance = nil

  def msg_get(*msg_id)
    arr = IO.readlines("/opt/application/current/app/assets/images/message.txt")
    if msg_id.length == 1
      for word in arr
        if word.include?(msg_id[0])
          return word.gsub!(msg_id[0] + ',', msg_id[0] + " : " ).gsub!(/\n/, "")
        end
      end
    else
      for word in arr
        if word.include?(msg_id[0])
          msgdata = word.gsub!(msg_id[0] + ',', msg_id[0] + " : " ).gsub!(/\n/, "")
          for i in 1...msg_id.length
            pp msg_id[i]
            msgdata = msgdata.gsub!('{' + i.to_s + '}', msg_id[i])
          end
          return msgdata
        end
      end
    end

  end

  def self.instance
		@@instance = new unless @@instance
  end

end