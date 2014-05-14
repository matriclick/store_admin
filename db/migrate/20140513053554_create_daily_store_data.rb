class CreateDailyStoreData < ActiveRecord::Migration
  def change
    create_table :daily_store_data do |t|
      t.datetime :date
      t.integer :came_in_clients
      t.integer :supplier_account_id

      t.timestamps
    end
  end
end
