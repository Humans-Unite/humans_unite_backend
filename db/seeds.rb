# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#   

INDIAN_CITIES = ['Mumbai', 'Delhi', 'Bangalore', 'Hyderabad', 'Ahmedabad', 'Pune', 'Kolkata', 'Chennai', 'Jaipur']
INDIAN_STATES = ['Maharashtra', 'Delhi', 'Karnataka', 'Telangana', 'Gujarat', 'West Bengal', 'Tamil Nadu', 'Rajasthan']

# Generate fake Indian phone numbers
def indian_phone_number
  "+91-#{rand(7000000000..9999999999)}"
end

# Create Organizations
20.times do
  User.create!(
    name: Faker::Company.name,
    email: Faker::Internet.unique.email,
    password: Devise::Encryptor.digest(User, 'password'),
    type: 'Organization',
    city: INDIAN_CITIES.sample,
    state: INDIAN_STATES.sample,
    contact_info: indian_phone_number,
    description: Faker::Company.catch_phrase,
    created_at: Time.now,
    updated_at: Time.now
  )
end