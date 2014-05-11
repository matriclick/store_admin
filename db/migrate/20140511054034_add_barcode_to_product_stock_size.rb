class AddBarcodeToProductStockSize < ActiveRecord::Migration
  def change
    add_column :product_stock_sizes, :barcode, :string
  end
end
