class CreateGiftCardsShoppingCartItems < ActiveRecord::Migration
  def change
    create_table :gift_cards_shopping_cart_items, :id => false do |t|
      t.integer :shopping_cart_item_id
      t.integer :gift_card_id
    end
  end
end
