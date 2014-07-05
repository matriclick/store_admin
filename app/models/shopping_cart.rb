class ShoppingCart < ActiveRecord::Base
  has_many :shopping_cart_items, :dependent => :destroy
  has_one :purchase, :dependent => :destroy
  
  def price
    price = 0
    self.shopping_cart_items.each do |sci|
      price = price + sci.product_stock_size.product.price
    end
    return price
  end
end
