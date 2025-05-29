class PaymentTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :community, optional: true
  has_one :finance
  # Validations
  validates :is_community, inclusion: { in: [ true, false ] }

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
