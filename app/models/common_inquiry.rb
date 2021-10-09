class CommonInquiry < ApplicationRecord
  belongs_to :system

  validates :sort_order, presence: true, length: { in: 1..5 }, numericality: true
  validates :question, presence: true, length: { maximum: 500 }
  validates :answer, presence: true, length: { maximum: 500 }

  scope :search_at_system_id, -> (system_id) { 
    where(system_id: system_id).order(sort_order: :asc)
  }
end
