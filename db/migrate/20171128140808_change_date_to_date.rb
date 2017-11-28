class ChangeDateToDate < ActiveRecord::Migration[5.1]
  def change
    remove_column :requests, :start_date, :string
    remove_column :requests, :end_date, :string
    add_column :requests, :start_date, :date
    add_column :requests, :end_date, :date
  end
end
