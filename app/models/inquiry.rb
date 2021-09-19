class Inquiry < ApplicationRecord
  belongs_to :system
  belongs_to :user
  belongs_to :inquiry_classification
  belongs_to :inquirier_kind
  belongs_to :approver, class_name: 'User'
  belongs_to :inquiry_relation

  validates :inquiry_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :company_name, presence: true, length: { maximum: 30 }
  validates :telephone_number, presence: true, length: { maximum: 13 }
  validates :sub_telephone_number, length: { maximum: 13 }
  validates :inquirier_name, presence: true, length: { maximum: 30 }
  validates :question, presence: true, length: { maximum: 500 }
  validates :answer, presence: true, length: { maximum: 500 }

  enum is_completeds: { incomplete: false, complete: true }
  enum inquiry_method_ids: { telephone: 1, mail: 2, direct: 3, other: 4 }

  scope :without_deleted, -> { where(deleted_at: nil) }

  def system_name
    return system.name
  end

  def user_name
    return user.name
  end

  def inquiry_datetime_text
    date = self.inquiry_date.strftime('%Y-%m-%d')
    time = self.start_time.strftime('%H:%M')

    return date + time
  end

  def self.complete_options
    return { '未完了' => is_completeds[:incomplete], '完了' => is_completeds[:complete], }
  end

  def self.inquiry_method_options
    return {
      '電話' => inquiry_method_ids[:telephone],
      'メール' => inquiry_method_ids[:mail],
      '直接' => inquiry_method_ids[:direct],
      'その他' => inquiry_method_ids[:other],
    }
  end

  def self.search_related_inquiries(tel_no, sub_tel_no)
    inquiries = without_deleted
                  .where(telephone_number: tel_no)
                  .or(
                    where(sub_telephone_number: sub_tel_no)
                  )
                  .order(inquiry_date: :desc)
                  .order(start_time: :desc)

    return inquiries
  end
end
