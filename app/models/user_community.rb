class UserCommunity < ApplicationRecord
  belongs_to :user
  belongs_to :community
  # Validations
  validates :approved, presence: true

  enum :type, {
    member: 0,
    subscriber: 1
  }

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
