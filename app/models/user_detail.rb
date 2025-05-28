class UserDetail < ApplicationRecord
  belongs_to :user
  # Validations
  validates :address, presence: true
  validates :phone_number, presence: true

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "address", "phone_number", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user" ]
  end
end
