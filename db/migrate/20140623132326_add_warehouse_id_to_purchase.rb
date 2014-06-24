class AddWarehouseIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :warehouse_id, :integer
  end
end
