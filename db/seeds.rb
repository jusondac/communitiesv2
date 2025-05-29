# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'
puts "Seeding database..."
puts "Cleaning up existing data..."
User.destroy_all
Community.destroy_all
Payment.destroy_all
Finance.destroy_all
PaymentMethod.destroy_all
UserCommunity.destroy_all

users = []
puts "Creating default user..."
users << User.create(
  username: "Megan Fox",
  email_address: "user@gmail.com",
  password: "q1w2e3r4",
  password_confirmation: "q1w2e3r4"
)

puts "Creating 20 random users..."
20.times do
  username = Faker::Internet.unique.username(specifier: 5..10)
  users << User.create!(
    email_address: "#{username}#{rand(1000)}@gmail.com",
    password: "password123",
    password_confirmation: "password123",
    username: username
  )
end


puts "Creating payment methods..."
paymentMethods = [
  { name: "Credit Card" },
  { name: "PayPal" },
  { name: "Bank Transfer" },
  { name: "App" },
  { name: "Cash" }
]
PaymentMethod.create!(paymentMethods) unless PaymentMethod.exists?


puts "Creating communities..."
communities = [
  { name: "Ruby Enthusiasts", description: "A community for Ruby language lovers." },
  { name: "Gamers United", description: "Where gamers connect and share experiences." },
  { name: "Startup Founders", description: "Networking and support for startup founders." },
  { name: "Bookworms", description: "A place for people who love to read and discuss books." },
  { name: "Fitness Freaks", description: "Motivation and tips for fitness enthusiasts." }
]
# Create communities
# Using find_or_create_by! to ensure idempotency
# This will not create duplicates if the community already exists
# It will raise an error if the community cannot be created due to validation errors


created_communities = []
communities.each do |community_attrs|
  created_communities << Community.find_or_create_by!(community_attrs)
end

puts "Creating user-community relationships..."
# Randomly assign users to communities
created_communities.each do |community|
  # Each community gets 5-15 random members
  sample_users = User.all.sample(rand(5..15))
  sample_users.each do |user|
    UserCommunity.find_or_create_by!(user: user, community: community, user_type: rand(0..1), approved: true)
  end
end

puts "Creatign finances for each community"

# Create finances for communities
created_communities.each do |community|
  community.create_finance(balance: rand(1000..5000), name: community.name)
end
# Create some random finances for users
