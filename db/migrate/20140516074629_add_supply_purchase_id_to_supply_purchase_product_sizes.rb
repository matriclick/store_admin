class AddSupplyPurchaseIdToSupplyPurchaseProductSizes < ActiveRecord::Migration
  def change
    add_column :supply_purchase_product_sizes, :supply_purchase_id, :integer
  end
end
