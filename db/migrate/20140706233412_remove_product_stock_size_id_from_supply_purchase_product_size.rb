class RemoveProductStockSizeIdFromSupplyPurchaseProductSize < ActiveRecord::Migration
  def change
    remove_column :supply_purchase_product_sizes, :product_stock_size_id
  end
end
