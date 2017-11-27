class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :products
  has_many :reviews
  has_many :requests
  has_many :conversations

  mount_uploader :profile_photo, PhotoUploader
  # validates :first_name, :last_name, :email, :password, presence: true
  # TO DO: mount_uploader :photo, PhotoUploader

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
