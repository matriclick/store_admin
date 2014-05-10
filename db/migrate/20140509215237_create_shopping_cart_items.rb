class CreateShoppingCartItems < ActiveRecord::Migration
  def change
    create_table :shopping_cart_items do |t|
      t.integer :shopping_cart_id
      t.integer :product_id
      t.integer :quantity

      t.timestamps
    end
  end
end
