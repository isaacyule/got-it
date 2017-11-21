class ChangeColumnType < ActiveRecord::Migration[5.1]
  def change
    change_column :requests, :start_date, :string
    change_column :requests, :end_date, :string
  end
end
