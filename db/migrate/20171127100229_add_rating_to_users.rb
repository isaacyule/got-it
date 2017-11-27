class AddRatingToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :rating, :float, :default => 0
  end
end
