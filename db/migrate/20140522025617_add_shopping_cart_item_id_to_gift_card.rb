class AddShoppingCartItemIdToGiftCard < ActiveRecord::Migration
  def change
    add_column :gift_cards, :shopping_cart_item_id, :integer
  end
end
