class Inquiry < ApplicationRecord
  belongs_to :system
  belongs_to :user
  belongs_to :inquiry_classification
  belongs_to :inquirier_kind
  belongs_to :approver, class_name: 'User', optional: true
  belongs_to :parent_inquiry, class_name: 'Inquiry', optional: true

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

  def approver_name
    return '' if self.approver.blank?
    return self.approver.name
  end

  def approve_datetime
    return '' if self.approve_at.blank?
    return self.approve_at.try!(:strftime, '%Y-%m-%d %H:%M')
  end

  def inquiry_datetime_text
    date = self.inquiry_date.strftime('%Y-%m-%d')
    time = self.start_time.strftime('%H:%M')

    return date + ' ' + time
  end

  def display_parent_inquiry
    return nil if parent_inquiry.blank?
    return inquiry_datetime_text + ' ' + parent_inquiry.company_name
  end

  def parent_inquiries
    parents = []
    inquiry = self.parent_inquiry
    loop do
      if inquiry.blank?
        break
      end

      parents << inquiry
      inquiry = inquiry.parent_inquiry
    end

    return parents
  end

  def logical_delete
    self.update!(deleted_at: DateTime.now)
  end

  def resurrect
    self.update!(deleted_at: nil)
  end

  def deleted?
    self.deleted_at.present?
  end

  def approve(user)
    self.update!(
      approver_id: user.id,
      approve_at: Time.zone.now
    )
  end

  def approve_cancel
    self.update!(
      approver_id: nil,
      approve_at: nil,
    )
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

  def self.search_related_inquiries(except_id, tel_no, sub_tel_no)
    except_id = except_id.blank? ? 0 : except_id
    inquiries = without_deleted
                  .where.not(id: except_id)
                  .where(telephone_number: tel_no)
                  .or(
                    where(telephone_number: sub_tel_no)
                  )
                  .order(inquiry_date: :desc)
                  .order(start_time: :desc)

    return inquiries
  end
end
