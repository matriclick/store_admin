class CreateWarehouseProductSizeStocks < ActiveRecord::Migration
  def change
    create_table :warehouse_product_size_stocks do |t|
      t.integer :product_stock_size_id
      t.integer :warehouse_id

      t.timestamps
    end
  end
end
