class Product < ApplicationRecord
  include AlgoliaSearch
  belongs_to :user
  has_many :requests
  has_many :reviews, through: :requests, dependent: :destroy


  # --- Google Maps api ---
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  # -----------------------


  # --- Cloudinary --------
  mount_uploader :photo, PhotoUploader
  # -----------------------


  # --- Algolia Search ---
  algoliasearch do
    attribute :name, :description, :price_per_day, :deposit, :address, :minimum_fee, :user_id, :photo
    geoloc :latitude, :longitude
    searchableAttributes ['name', 'description']
  end
  # ----------------------
end
