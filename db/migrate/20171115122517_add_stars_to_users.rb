class AddStarsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stars, :integer, default: 0
  end
end
