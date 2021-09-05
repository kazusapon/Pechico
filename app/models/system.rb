class System < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :short_name, presence: true, uniqueness: true, length: { maximum: 10 }
end
