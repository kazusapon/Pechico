class Inquiry < ApplicationRecord
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
end
