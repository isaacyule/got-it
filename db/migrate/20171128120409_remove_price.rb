class RemovePrice < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :price_per_day
  end
end
