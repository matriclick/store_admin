class CreateInventoryReconciliations < ActiveRecord::Migration
  def change
    create_table :inventory_reconciliations do |t|
      t.integer :supplier_account_id
      t.integer :user_id
      t.text :comments

      t.timestamps
    end
  end
end
