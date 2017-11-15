class RemoveHouseFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :house_number, :integer
  end
end
