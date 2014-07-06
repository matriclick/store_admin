class AddUpdateStockToSupplyPurchaseProductSize < ActiveRecord::Migration
  def change
    add_column :supply_purchase_product_sizes, :update_stock, :boolean
  end
end
