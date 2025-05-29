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

  # Scopes
  scope :for_current_user, -> {
    user_finance_id = Current.user&.finance&.id
    where("payer_id = ? OR receiver_id = ?", user_finance_id, user_finance_id)
  }

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "payer_id", "receiver_id", "amount", "status", "category", "created_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "payer", "receiver", "payment_method" ]
  end
end
