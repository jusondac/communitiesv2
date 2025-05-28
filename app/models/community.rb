class Community < ApplicationRecord
  # Associations
  has_many :user_communities, dependent: :destroy
  has_many :users, through: :user_communities
  has_many :members, -> { where(user_communities: { user_type: "member" }) }, through: :user_communities, source: :user
  has_many :subscribers, -> { where(user_communities: { user_type: "subscriber" }) }, through: :user_communities, source: :user

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
