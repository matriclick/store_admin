class ShoppingCart < ActiveRecord::Base
  has_many :shopping_cart_items, :dependent => :destroy
  has_one :purchase
  
  def price
    price = 0
    self.shopping_cart_items.each do |sci|
      unless sci.price.blank?
        price = price + sci.price
      else
        price = price + sci.product_stock_size.product.price
      end
    end
    return price
  end
end
