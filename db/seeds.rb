# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)
# require 'json'
# require 'open-uri'
# require 'faker'

# puts "cleaning database..."
User.destroy_all
Product.destroy_all
# puts "seeding"

# -------------- Seed Users --------------

20.times do |iteration|
  url             = 'https://randomuser.me/api/?nat=gb'
  user_serialized = open(url).read
  user            = JSON.parse(user_serialized)

  first_name        = ["Sara", "John", "David", "Emma", "Michael", "Karabo", "Sam", "Frank", "Judie", "Jonas", "Kathrin", "Julia", "Jens", "Philip", "Junjie", "Sandra", "Anna", "Margarita", "Marleny", "Laura"].sample
  last_name         = user['results'][0]['name']['last']
  password          = "#{user['results'][0]['login']['password']}12345"
  email             = "#{iteration}#{user['results'][0]['email']}"
  IMG = {
    Sara: 'app/assets/images/Face1.jpg',
    John: 'app/assets/images/Face2.jpg',
    David: 'app/assets/images/Face3.jpg',
    Sam: 'app/assets/images/Face4.jpg',
    Frank: 'app/assets/images/Face5.jpg',
    Jonas: 'app/assets/images/Face6.jpg',
    Emma: 'app/assets/images/Face7.jpg',
    Michael: 'app/assets/images/Face8.jpg',
    Judie: 'app/assets/images/Face9.jpg',
    Karabo: 'app/assets/images/Face10.jpg',
    Margarita: 'app/assets/images/Face11.jpg',
    Kathrin: 'app/assets/images/Face12.jpg',
    Julia: 'app/assets/images/Face13.jpg',
    Sandra: 'app/assets/images/Face14.jpg',
    Laura: 'app/assets/images/Face15.jpg',
    Jens: 'app/assets/images/Face16.jpg',
    Philip: 'app/assets/images/Face17.jpg',
    Marleny: 'app/assets/images/Face18.jpg',
    Anna: 'app/assets/images/Face19.jpg',
    Junjie: 'app/assets/images/Face20.jpg',
  }

  address           = ["100 The Mall, London, WC2N 5DU, England", "110 Kingsland Rd, London, E2 8AH, England", "8 Exmouth Market, London, EC1R 4QA, England", "44 Sutherland St, London, SW1V 4JZ, England", "16 Barford St, London, N1 0QB, England", "10 Thurtle Rd, London, E2, England", "5 Porter St, London, SE1 9HD, England", "25 Philpot Ln, London, EC3M, England", "13 Finsbury St, London, EC2Y, England", "1 Memel St, London, EC1Y, England"].sample
  profile_text      = Faker::MostInterestingManInTheWorld.quote
  phone             = user['results'][0]['phone']
  registration_date = user['results'][0]['registered']
  puts "writing #{first_name.capitalize} #{last_name.capitalize}..."
  new_user = User.new(first_name: first_name, last_name: last_name, password: password, email: email, profile_text: profile_text, phone: phone, registration_date: registration_date, address: address)
  new_user.profile_photo = Rails.root.join(IMG[first_name.to_sym]).open
  new_user.save
end

# -------------- Seed Products --------------

names = ['Electronics Repair Kit', 'Mountain Bike', 'Road Bike', 'Electric Guitar', 'Home Barbeque', 'Six Person Tent', 'Golf clubs', 'Go Pro', 'High End Digital Camera', 'Gardening Equipment', 'Cement Mixer', 'Fancy Dress Costume', 'Tuxedo', 'Sewing Machine', 'Plumbing Equipment', 'Flatbed Trailer', 'Car Jack']
description = "A useful product that you can rent"
condition = "as new"
price_per_day_pennies = [500, 1000, 1500, 2000, 700, 800, 900, 1100, 1200, 1300, 1400]
handover_fee = [5, 10, 15, 20]
user_id = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
PIC = {
  electronics_repair_kit: 'app/assets/images/electronic_repair_kit.jpg',
  mountain_bike: 'app/assets/images/mountain_bike.jpg',
  electric_guitar: 'app/assets/images/electric_guitar.jpg',
  home_barbeque: 'app/assets/images/home_barbeque.jpg',
  six_person_tent: 'app/assets/images/6_person_tent.jpg',
  golf_clubs: 'app/assets/images/golf_clubs.jpg',
  go_pro: 'app/assets/images/go_pro.jpg',
  high_end_digital_camera: 'app/assets/images/high_end_digital_camera.jpg',
  gardening_equipment: 'app/assets/images/gardening_equipment.jpg',
  cement_mixer: 'app/assets/images/cement_mixer.jpg',
  fancy_dress_costume: 'app/assets/images/fancy_dress_costume.jpg',
  tuxedo: 'app/assets/images/tuxedo.jpg',
  sewing_machine: 'app/assets/images/sewing_machine.jpg',
  plumbing_equipment: 'app/assets/images/plumbing_equipment.jpg',
  flatbed_trailer: 'app/assets/images/flatbed_trailer.jpg',
  car_jack: 'app/assets/images/car_jack.jpg',
  road_bike: 'app/assets/images/road_bike.jpg'
}

50.times do |iteration|
  name = names.sample
  products_user_id = user_id.sample
  user = User.find(products_user_id)
  address = user.address
  image = name.downcase.gsub(/\s/, '_').to_sym
  puts "creating #{name} with image #{image} which can be found at #{PIC[image]}"
  new_product = Product.new(name: name, description: description, condition: condition, price_per_day_pennies: price_per_day_pennies.sample.to_i, deposit: price_per_day_pennies.sample.to_i/1000, handover_fee: handover_fee.sample, user_id: products_user_id, address: address)
  new_product.photo = Rails.root.join(PIC[image]).open
  new_product.save
  puts "added product #{iteration}"
end

Product.reindex!

puts "*** Seeding Complete ***"
puts "*** Seeded #{Product.count} products ***"
puts "*** Seeded #{User.count} users ***"
