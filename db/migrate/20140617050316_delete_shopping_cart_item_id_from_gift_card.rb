class DeleteShoppingCartItemIdFromGiftCard < ActiveRecord::Migration
  def change
    remove_column :gift_cards, :shopping_cart_item_id
  end
end
