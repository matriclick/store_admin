class AddProductStockSizeBarcodeToSupplyPurchase < ActiveRecord::Migration
  def change
    add_column :supply_purchase_product_sizes, :product_stock_size_barcode, :string
  end
end
