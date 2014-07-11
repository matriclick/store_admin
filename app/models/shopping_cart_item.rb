class ShoppingCartItem < ActiveRecord::Base
  before_create :set_price
  belongs_to :shopping_cart
  belongs_to :product_stock_size
  has_one :product, through: :product_stock_size
  has_and_belongs_to_many :gift_cards
  
  def gift_card
    self.gift_cards.first
  end
  
  def set_price
    self.price = self.product.price
  end
end
