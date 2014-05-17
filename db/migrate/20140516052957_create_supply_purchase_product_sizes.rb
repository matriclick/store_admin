class CreateSupplyPurchaseProductSizes < ActiveRecord::Migration
  def change
    create_table :supply_purchase_product_sizes do |t|
      t.integer :product_stock_size_id
      t.integer :quantity
      t.decimal :unit_cost
      t.integer :currency_id

      t.timestamps
    end
  end
end
