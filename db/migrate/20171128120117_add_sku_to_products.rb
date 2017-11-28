class AddSkuToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :sku, :string
  end
end
