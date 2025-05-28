class Community < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :description, presence: true

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "description", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
