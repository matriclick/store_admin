class CreateProductStockSizes < ActiveRecord::Migration
  def change
    create_table :product_stock_sizes do |t|
      t.integer :product_id
      t.integer :size_id
      t.string :color
      t.integer :stock

      t.timestamps
    end
  end
end
