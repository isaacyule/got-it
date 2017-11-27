class Ureview < ApplicationRecord
  belongs_to :user
  belongs_to :request
  validates :user, uniqueness: { scope: :request, message: "You have already reviewed this item" }
  validates :content, length: { minimum: 20 }
  validates :overall, presence: true
end
