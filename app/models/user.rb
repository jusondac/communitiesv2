class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_communities, dependent: :destroy
  has_many :communities, through: :user_communities

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
