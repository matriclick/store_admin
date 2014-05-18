class AddWarehouseIdToDailyStoreData < ActiveRecord::Migration
  def change
    add_column :daily_store_data, :warehouse_id, :integer
  end
end
