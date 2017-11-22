class AddColumnsToReviews < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :handover, :integer
    add_column :reviews, :accuracy, :integer
    add_column :reviews, :quality, :integer
    add_column :reviews, :overall, :integer
    add_column :reviews, :photo, :string
  end
end
