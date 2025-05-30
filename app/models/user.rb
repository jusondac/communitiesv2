class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_communities, dependent: :destroy
  has_many :communities, through: :user_communities
  has_one :user_detail, dependent: :destroy
  belongs_to :finance, optional: true
  has_many :payment_transactions, dependent: :destroy
  has_many :sent_payments, class_name: "Payment", foreign_key: "payer_id", dependent: :destroy
  has_many :received_payments, class_name: "Payment", foreign_key: "receiver_id", dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  scope :with_finance, -> { where.not(finance_id: nil) }

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "email_address", "username", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user_detail", "user_communities", "communities" ]
  end
end
