class UnregisterInquiry < ApplicationRecord
  after_create :notify_incoming_call

  def inquiry_datetime
    date = self.inquiry_date.strftime('%Y-%m-%d')
    time = self.start_time.strftime('%H:%M')

    return date + ' ' + time
  end

  def self.search(user)
    return UnregisterInquiry.where(user_id: user.id)
                            .or(
                              where('user_id IS NULL')
                            )
                            .order(inquiry_date: :desc)
                            .order(start_time: :desc)
  end
 
  private

  # 着信を通知する
  def notify_incoming_call
    ActionCable.server.broadcast("cti_channel", {})
  end
end
