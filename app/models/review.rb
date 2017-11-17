  class Review < ApplicationRecord
  belongs_to :user
  belongs_to :request
  validates :content, length: { minimum: 20 }
end
