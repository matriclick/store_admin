class CreateProductReconciliations < ActiveRecord::Migration
  def change
    create_table :product_reconciliations do |t|
      t.integer :inventory_reconciliation_id
      t.integer :product_stock_size_id
      t.integer :count

      t.timestamps
    end
  end
end
