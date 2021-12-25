class UnregisterInquiry < ApplicationRecord
  belongs_to :inquirier_kind, optional: true

  after_create :notify_incoming_call

  def inquiry_datetime
    date = self.inquiry_date.strftime('%Y-%m-%d')
    time = self.start_time.strftime('%H:%M')

    return date + ' ' + time
  end

  def can_resume?
    self.end_time.blank?
  end

  def elapsed_time
    now = Time.now
    datetime = Time.parse(self.inquiry_datetime)
    diff = now - datetime

    return Time.at(diff)
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
    data = {}
    data[:id] = self.id
    data[:datetime] = self.inquiry_datetime
    data[:company_name] = self.company_name.blank? ? '新規' : self.company_name
    data[:inquirier_name] = self.inquirier_name
    data[:telephone_number] = self.telephone_number
    data[:inquirier_kind] = self.inquirier_kind.blank? ? '' : self.inquirier_kind.name
    
    ActionCable.server.broadcast("cti_channel", data)
  end
end
