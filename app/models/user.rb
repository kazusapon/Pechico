class User < ApplicationRecord
  has_secure_password
  acts_as_paranoid

  validates :name, presence: true
  validates :login_id, presence: true, uniqueness: true
  validates :password, confirmation: true, allow_blank: true
  validates :password_confirmation, presence: true, allow_blank: true

end
