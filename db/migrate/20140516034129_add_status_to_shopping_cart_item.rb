class AddStatusToShoppingCartItem < ActiveRecord::Migration
  def change
    add_column :shopping_cart_items, :status, :string
  end
end
