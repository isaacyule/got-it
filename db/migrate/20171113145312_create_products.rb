class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price_per_day
      t.string :deposit
      t.integer :minimum_fee
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
