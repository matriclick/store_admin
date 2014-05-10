class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :buyer_email
      t.integer :payment_method_id
      t.integer :shopping_cart_id

      t.timestamps
    end
  end
end
