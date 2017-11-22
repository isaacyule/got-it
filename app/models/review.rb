class Review < ApplicationRecord
  belongs_to :user
  belongs_to :request
  validates :user, uniqueness: { scope: :request, message: "You have already reviewed this item" }
  validates :content, length: { minimum: 20 }
  validates :handover, :accuracy, :quality, :overall, presence: true
end
