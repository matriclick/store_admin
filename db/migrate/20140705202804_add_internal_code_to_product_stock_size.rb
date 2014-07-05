class AddInternalCodeToProductStockSize < ActiveRecord::Migration
  def change
    add_column :product_stock_sizes, :internal_code, :string
  end
end
