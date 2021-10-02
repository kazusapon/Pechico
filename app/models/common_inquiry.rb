class CommonInquiry < ApplicationRecord
  belongs_to :system

  validates :sort_order, presence: true, length: { in: 1..5 }, numericality: true
  validates :question, presence: true, length: { maximum: 500 }
  validates :answer, presence: true, length: { maximum: 500 }
end
