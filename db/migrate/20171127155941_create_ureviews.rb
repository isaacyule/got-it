class CreateUserReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :ureviews do |t|
      t.text :content
      t.integer :rating
      t.references :user, foreign_key: true
      t.references :request, foreign_key: true

      t.timestamps
    end
  end
end
