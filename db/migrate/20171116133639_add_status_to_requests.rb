class AddStatusToRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :status, :string
    add_column :requests, :status, :string, :default => "Pending"
  end
end
