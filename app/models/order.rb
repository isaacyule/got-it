class Order < ApplicationRecord
  monetize :amount_pennies
  belongs_to :user
  belongs_to :product
end
