class ShoppingCartItem < ActiveRecord::Base
  belongs_to :shopping_cart
  belongs_to :product_stock_size
  has_and_belongs_to_many :gift_cards
  
  def gift_card
    self.gift_cards.first
  end
end
