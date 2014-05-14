class AddWarehouseIdToProductStockSize < ActiveRecord::Migration
  def change
    add_column :product_stock_sizes, :warehouse_id, :integer
  end
end
