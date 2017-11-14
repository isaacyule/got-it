class Product < ApplicationRecord
  belongs_to :user
  has_many :requests

  mount_uploader :photo, PhotoUploader
end
