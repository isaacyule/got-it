class RemoveColumnsFromReviews < ActiveRecord::Migration[5.1]
  def change
    remove_column :reviews, :handover, :integer
    remove_column :reviews, :accuracy, :integer
    remove_column :reviews, :quality, :integer
  end
end
