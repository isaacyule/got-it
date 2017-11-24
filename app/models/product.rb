class Product < ApplicationRecord
  include AlgoliaSearch
  belongs_to :user
  has_many :requests
  has_many :reviews, through: :requests, dependent: :destroy
  validates :photo, presence: true

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
    attribute :name, :description, :price_per_day, :deposit, :address, :handover_fee, :user_id, :average_rating
    attribute :photo do
      return nil if self.photo.nil?
      # return self.photo.metadata['url'] if self.photo.metadata.present?
      self.photo.url
    end
    attribute :owner_photo do
      return nil if self.user.profile_photo.nil?
      # return self.user.profile_photo.metadata['url'] if self.user.profile_photo.metadata.present?
      self.user.profile_photo.url
    end

    attribute :rating_count do
      self.reviews.count
    end

    geoloc :latitude, :longitude
    searchableAttributes ['name', 'description']
  end
  # ----------------------

  private

  def average_rating
    self.reviews.average(:overall)
  end
end
