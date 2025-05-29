class Payment < ApplicationRecord
  belongs_to :payment_method, optional: true
  belongs_to :payer, class_name: "Finance"
  belongs_to :receiver, class_name: "Finance", optional: true

  # Enums
  enum :category, { transfer: 0, donation: 1, service: 2 }
  enum :status, { pending: 0, completed: 1, failed: 2 }

  # Validations
  validates :payer_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
