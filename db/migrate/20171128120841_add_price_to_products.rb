class AddPriceToProducts < ActiveRecord::Migration[5.1]
  def change
    add_monetize :products, :price_per_day, currency: { present: false }
  end
end
