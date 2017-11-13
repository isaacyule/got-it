class Request < ApplicationRecord
  belongs_to :user
  belongs_to :product
  validates :user_id, :product_id, presence: true
end
