class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :minimum_fee, :handover_fee
  end
end
