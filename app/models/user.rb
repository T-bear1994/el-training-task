class User < ApplicationRecord
  has_many :tasks
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true
  validates :password_digest, presence: true, uniqueness: true
end
