class Request < ApplicationRecord
  belongs_to :user
  belongs_to :product
  validates :user_id, :product_id, presence: true
  validates_uniqueness_of :product_id, scope: :user
end
