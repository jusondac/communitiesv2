class Community < ApplicationRecord
  # Associations
  has_many :user_communities, dependent: :destroy
  has_many :users, through: :user_communities
  belongs_to :finance, optional: true
  has_many :members, -> { where(user_communities: { user_type: "member" }) }, through: :user_communities, source: :user
  has_many :subscribers, -> { where(user_communities: { user_type: "subscriber" }) }, through: :user_communities, source: :user


  # Validations
  validates :name, presence: true
  validates :description, presence: true

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "description", "created_at", "updated_at" ]
  end

  def self.has_finance?
    community.finance
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
