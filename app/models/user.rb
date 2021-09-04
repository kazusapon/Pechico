class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :login_id, presence: true, uniqueness: true
  validates :password, confirmation: true, allow_blank: true
  validates :password_confirmation, presence: true, allow_blank: true

  def logical_delete
    self.deleted_at = DateTime.now
    self.save!
  end

  def reborn
    self.deleted_at = nil
    self.save!
  end

  def deleted?
    return self.deleted_at.present?
  end
end
