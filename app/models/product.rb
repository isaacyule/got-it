class Product < ApplicationRecord
  include AlgoliaSearch
  belongs_to :user
  has_many :requests
  has_many :reviews, through: :requests, dependent: :destroy

  # after_commit :index_in_algolia


  # --- Google Maps api ---
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  # -----------------------


  # --- Cloudinary --------
  mount_uploader :photo, PhotoUploader
  # -----------------------


  # --- Algolia Search ---
  algoliasearch do
    attribute :name, :description, :price_per_day, :deposit, :address, :handover_fee, :user_id
    attribute :photo do
      self.photo.metadata['url']
    end
    geoloc :latitude, :longitude
    searchableAttributes ['name', 'description']
  end
  # ----------------------

  private

  # def index_in_algolia
  #   self.index!
  # end
end
