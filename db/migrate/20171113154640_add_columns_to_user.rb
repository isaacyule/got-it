class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :profile_photo, :string
    add_column :users, :profile_text, :string
    add_column :users, :street, :string
    add_column :users, :town, :string
    add_column :users, :postcode, :string
    add_column :users, :country, :string
    add_column :users, :phone, :string
    add_column :users, :registration_date, :string
  end
end
