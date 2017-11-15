class Product < ApplicationRecord
  belongs_to :user
  has_many :requests

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  mount_uploader :photo, PhotoUploader
end


# p = Product.new(name: "hello", address: "138 kingsland road london")
