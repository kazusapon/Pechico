class UnregisterInquiry < ApplicationRecord
  def inquiry_datetime
    date = self.inquiry_date.strftime('%Y-%m-%d')
    time = self.start_time.strftime('%H:%M')

    return date + ' ' + time
  end
end
