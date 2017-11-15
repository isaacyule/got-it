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
  url             = 'https://randomuser.me/api/?nat=gb'
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
  address           = "#{street}, #{town}, #{postcode}"
  puts "writing #{first_name.capitalize} #{last_name.capitalize}..."
  User.create!(first_name: first_name, last_name: last_name, password: password, email: email, profile_photo: profile_photo, profile_text: profile_text, address: address, phone: phone, registration_date: registration_date)
end

# Seed Products

names = ['Electronics Repair Kit', 'Mountain Bike', 'Electric Guitar', 'Home Barbeque', 'Six Person Tent', 'Golf clubs', 'Go-Pro', 'High-End Digital Camera', 'Gardening Equipment', 'Cement Mixer', 'Fancy Dress Costume', 'Tuxedo', 'Sewing Machine', 'Plumbing Equipment', 'Flatbed Trailer', 'Car Jack']
description = "A useful product that you can rent"
price_per_day = [5, 10, 15, 20, 7, 8, 9, 11, 12, 13, 14]
minimum_fee = [5, 10, 15, 20]
user_id = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
img = {
  electronics_repair_kit: '../app/assets/images/electronic_repair_kit.jpg',
  mountain_bike: '../app/assets/images/mountain_bike.jpg',
  electric_guitar: '../app/assets/images/electric_guitar.jpg',
  home_barbeque: '../app/assets/images/home_barbeque.jpg',
  six_person_tent: '../app/assets/images/6_person_tent.jpg',
  golf_clubs: '../app/assets/images/golf_clubs.jpg',
  go_pro: '../app/assets/images/go_pro.jpg',
  high_end_digital_camera: '../app/assets/images/high_end_digital_camera.jpg',
  gardening_equipment: '../app/assets/images/gardening_equipment.jpg',
  cement_mixer: '../app/assets/images/cement_mixer.jpg',
  fancy_dress_costume: '../app/assets/images/fancy_dress_costume.jpg',
  tuxedo: '../app/assets/images/tuxedo.jpg',
  sewing_machine: '../app/assets/images/sewing_machine.jpg',
  plumbing_equipment: '../app/assets/images/plumbing_equipment.jpg',
  flatbed_trailer: '../app/assets/images/flatbed_trailer.jpg',
  car_jack: '../app/assets/images/car_jack.jpg'
}


50.times do |iteration|
  name = names.sample
  products_user_id = user_id.sample
  user = User.find(products_user_id)
  address = user.address
  image = name.downcase.gsub(/\s/, '_').to_sym
  puts "creating #{name} with image #{image} which can be found at #{img[image]}"
  Product.create!(name: name, description: description, price_per_day: price_per_day.sample, deposit: price_per_day.sample/10, minimum_fee: minimum_fee.sample, user_id: products_user_id, address: address, photo: img[image])
  puts "added product #{iteration}"
end

puts "*** Seeding Complete ***"
puts "*** Seeded #{Product.count} products ***"
puts "*** Seeded #{User.count} users ***"
