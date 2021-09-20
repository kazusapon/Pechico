class InquirierKind < ApplicationRecord
  has_many :inquiries, foreign_key: 'inquirier_kind_id'
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }

  scope :without_deleted, -> {
    where(deleted_at: nil).order(id: :asc)
  }

  def logical_delete
    self.update!(deleted_at: DateTime.now)
  end

  def resurrect
    self.update!(deleted_at: nil)
  end

  def deleted?
    self.deleted_at.present?
  end
end
