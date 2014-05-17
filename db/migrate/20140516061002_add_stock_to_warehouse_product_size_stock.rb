class AddStockToWarehouseProductSizeStock < ActiveRecord::Migration
  def change
    add_column :warehouse_product_size_stocks, :stock, :integer
  end
end
