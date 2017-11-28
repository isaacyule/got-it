  class Request < ApplicationRecord
  belongs_to :user
  belongs_to :product

  has_one :review
  has_one :ureview
  has_one :conversation, dependent: :destroy

  validates :user_id, :product_id, :start_date, :end_date, presence: true

  validates_uniqueness_of :product_id, { scope: :user,
    message: "already requested" }
end
