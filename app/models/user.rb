class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :login_id, presence: true, uniqueness: true
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  
end
