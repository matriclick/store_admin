class CreateSupplyPurchasePayments < ActiveRecord::Migration
  def change
    create_table :supply_purchase_payments do |t|
      t.integer :supply_purchase_id
      t.decimal :amount
      t.integer :currency_id
      t.boolean :paid
      t.datetime :pay_date

      t.timestamps
    end
  end
end
