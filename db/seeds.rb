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
Product.destroy_all
puts "seeding"

# Seed Users

20.times do |iteration|
  url             = 'https://randomuser.me/api/'
  user_serialized = open(url).read
  user            = JSON.parse(user_serialized)

  first_name        = user['results'][0]['name']['first']
  last_name         = user['results'][0]['name']['last']
  password          = "#{user['results'][0]['login']['password']}12345"
  email             = "#{iteration}#{user['results'][0]['email']}"
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

# Seed Products

name = ['Electronics Repair Kit', 'Mountain Bike', 'Electric Guitar', 'Home Barbeque', '6-person Tent', 'Golf clubs', 'Go-Pro', 'High-End Digital Camera', 'Gardening Equipment', 'Cement Mixer', 'Fancy Dress Costume', 'Tuxedo', 'Sewing Machine', 'Plumbing Equipment', 'Flat-bed Trailer', 'Car Jack']
description = "A useful product that you can rent"
price_per_day = [5, 10, 15, 20, 7, 8, 9, 11, 12, 13, 14]
minimum_fee = [5, 10, 15, 20]
user_id = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
photo = 'sample.jpg'
# created_at = '2001-02-03T04:05:06+00:00'
# updated_at = '2001-02-03T04:05:06+00:00'

50.times do |iteration|
  Product.create!(name: name.sample, description: description, price_per_day: price_per_day.sample, deposit: price_per_day.sample/10, minimum_fee: minimum_fee.sample, user_id: user_id.sample, photo: photo)
  puts "added product #{iteration}"
end

puts "*** Seeding Complete ***"
puts "*** Seeded #{Product.count} products ***"
puts "*** Seeded #{User.count} users ***"
