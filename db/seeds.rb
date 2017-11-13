# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'open-uri'
require 'faker'

puts "cleaning database..."
User.destroy_all
puts "seeding"

# create 100 random users
20.times do
  url             = 'https://randomuser.me/api/'
  user_serialized = open(url).read
  user            = JSON.parse(user_serialized)

  first_name        = user['results'][0]['name']['first']
  last_name         = user['results'][0]['name']['last']
  password          = "#{user['results'][0]['login']['password']}12345"
  email             = user['results'][0]['email']
  profile_photo     = user['results'][0]['picture']["large"]
  profile_text      = Faker::MostInterestingManInTheWorld.quote
  street            = user['results'][0]['location']['street']
  town              = user['results'][0]['location']['city']
  postcode          = user['results'][0]['location']['postcode']
  country           = user['results'][0]['nat']
  phone             = user['results'][0]['phone']
  registration_date = user['results'][0]['registered']
  puts "writing #{first_name.capitalize} #{last_name.capitalize}..."
  User.create!(first_name: first_name, last_name: last_name, password: password, email: email, profile_photo: profile_photo, profile_text: profile_text, street: street, town: town, postcode: postcode, country: country, phone: phone, registration_date: registration_date)
end

puts "*** Seeding Complete ***"
puts "*** Seeded #{User.count} users ***"
