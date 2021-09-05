class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { maximum: 10 }
  validates :login_id, presence: true, uniqueness: true, length: { maximum: 10 }, format: {with: /\A[a-zA-Z0-9]+\z/}
  validates :password, confirmation: true, allow_blank: true, length: { minimum: 4 }
  validates :password_confirmation, presence: true, allow_blank: true

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
