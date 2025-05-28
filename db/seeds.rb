# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding database..."
puts "Cleaning up existing data..."
User.destroy_all

puts "Creating default user..."
User.create(
  email_address: "user@gmail.com",
  password: "q1w2e3r4",
  password_confirmation: "q1w2e3r4"
)

puts "Creating communities..."
communities = [
  { name: "Ruby Enthusiasts", description: "A community for Ruby language lovers." },
  { name: "Gamers United", description: "Where gamers connect and share experiences." },
  { name: "Startup Founders", description: "Networking and support for startup founders." },
  { name: "Bookworms", description: "A place for people who love to read and discuss books." },
  { name: "Fitness Freaks", description: "Motivation and tips for fitness enthusiasts." }
]

communities.each do |community_attrs|
  Community.find_or_create_by!(community_attrs)
end
