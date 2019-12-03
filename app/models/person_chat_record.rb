class PersonChatRecord < ApplicationRecord
  def make_rc_uuid
    format(RC_DEFINE[:person_chat_rec_uuid_format].to_s, make_uuid)
  end

  def make_uuid
    SecureRandom.hex(10)
  end
end
