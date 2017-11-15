class RemoveStreetFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :street, :string
    remove_column :users, :town, :string
    remove_column :users, :postcode, :string
    remove_column :users, :country, :string
  end
end
