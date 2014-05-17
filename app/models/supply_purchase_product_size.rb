class SupplyPurchaseProductSize < ActiveRecord::Base
  include ActiveModel::Dirty
  
  before_save :update_stock
  
  belongs_to :supply_purchase
  belongs_to :product_stock_size
  
  def update_stock
    if self.quantity_changed?
      change = self.quantity - (self.quantity_was.nil? ? 0 : self.quantity_was)
      self.product_stock_size.update_attribute :stock, self.product_stock_size.stock + change
    else
      self.product_stock_size.update_attribute :stock, self.product_stock_size.stock + self.quantity
    end
  end
  
end
