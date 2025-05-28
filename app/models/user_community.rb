class UserCommunity < ApplicationRecord
  belongs_to :user
  belongs_to :community

  # Validations
  validates :approved, presence: true

  enum :user_type, {
    member: 0,
    subscriber: 1
  }

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "user_type", "approved", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user", "community" ]
  end
end
