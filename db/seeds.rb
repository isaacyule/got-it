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


# create 100 random users
100.times do {
  url             = 'https://randomuser.me/api/'
  user_serialized = open(url).read
  user            = JSON.parse(user_serialized)

  first_name    = user['results'][0]['name']['first']
  last_name     = user['results'][0]['name']['last']
  username      = user['results'][0]['login']['username']
  password      = user['results'][0]['login']['password']
  email         = user['results'][0]['email']
  profile_photo = user['results'][0]['picture']["large"]
  profile_text  = Faker::MostInterestingManInTheWorld.quote
  street        = user['results'][0]['location']['street']
  town          = user['results'][0]['location']['city']
  state         = user['results'][0]['location']['county']
  postcode      = user['results'][0]['location']['postcode']
  country       = user['results'][0]['nat']
  phone         = user['results'][0]['phone']
  registered    = user['results'][0]['registered']

  user.new(first_name: first_name, last_name: last_name, username: username, password: password, email: email, profile_photo: profile_photo, profile_text: profile_text, street: street, town: town, state: state, postcode: postcode, country: country, phone: phone, registered: registed)
}
