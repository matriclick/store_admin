class AddCostToProduct < ActiveRecord::Migration
  def change
    add_column :products, :cost, :decimal
    add_column :products, :provider_id, :integer
  end
end
