class UserCommunityRole < ApplicationRecord
  belongs_to :user_community
  # Validations
  validates :name, presence: true
  validates :position, presence: true
  validates :description, presence: true
  validates :parent_id, presence: true

  ## update the ransackable below with column you want to add ransack
  def self.ransackable_attributes(auth_object = nil)
    ["id"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end