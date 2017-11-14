class AddHouseNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :house_number, :integer
  end
end
