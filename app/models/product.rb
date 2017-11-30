class Product < ApplicationRecord
  include AlgoliaSearch
  belongs_to :user
  has_many :requests
  has_many :reviews, through: :requests, dependent: :destroy
  validates :photo, presence: true
  monetize :price_per_day_pennies

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
    attribute :name, :description, :price_per_day_pennies, :deposit, :address, :handover_fee, :user_id, :rating
    attribute :photo do
      self.algolia_photo
    end
    attribute :owner_photo do
      if self.algolia_owner_photo
        self.algolia_owner_photo.split("/").insert(6, 'c_fill,g_face,h_350,w_350').join('/')
      end
    end

    attribute :rating_count do
      self.reviews.count
    end

    geoloc :latitude, :longitude
    searchableAttributes ['name', 'description']
  end
  # ----------------------

  def algolia_photo
    return nil if self.photo.nil?
    return self.photo.metadata['url'] if self.photo.metadata.present?
    self.photo.url
  end

  def algolia_owner_photo
    return nil if self.user.profile_photo.nil?
    return self.user.profile_photo.metadata['url'] if self.user.profile_photo.metadata.present?
    self.user.profile_photo.url
  end

  private

  def average_rating
    self.reviews.average(:overall)
  end
end
