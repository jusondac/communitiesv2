class Finance < ApplicationRecord
  belongs_to :payment_transaction
  # Validations
  validates :balance, presence: true

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    ["id"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end