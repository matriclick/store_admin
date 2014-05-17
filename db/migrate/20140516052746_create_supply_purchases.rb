class CreateSupplyPurchases < ActiveRecord::Migration
  def change
    create_table :supply_purchases do |t|
      t.integer :provider_id
      t.decimal :total_paid
      t.integer :currency_id
      t.text :comments

      t.timestamps
    end
  end
end
