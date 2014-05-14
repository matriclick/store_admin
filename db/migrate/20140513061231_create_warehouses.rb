class CreateWarehouses < ActiveRecord::Migration
  def change
    create_table :warehouses do |t|
      t.integer :supplier_account_id
      t.string :name

      t.timestamps
    end
  end
end
