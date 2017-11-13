class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.string :status
      t.string :start_date
      t.string :end_date
      t.text :description

      t.timestamps
    end
  end
end
