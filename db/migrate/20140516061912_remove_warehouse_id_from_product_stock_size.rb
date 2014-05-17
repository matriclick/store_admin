class RemoveWarehouseIdFromProductStockSize < ActiveRecord::Migration
  def change
     remove_column :product_stock_sizes, :warehouse_id
  end
end
