class Payment < ApplicationRecord
  belongs_to :payment_method
  # Validations
  validates :created_at, presence: true
  validates :payer_id, presence: true
  validates :receiver_id, presence: true
  validates :category, presence: true
  validates :status, presence: true
  validates :amount, presence: true

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    ["id"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end