class SupplyPurchaseProductSize < ActiveRecord::Base
  include ActiveModel::Dirty
  before_save :update_stock_function
  
  belongs_to :supply_purchase
  belongs_to :product_stock_size, primary_key: "barcode", foreign_key: "product_stock_size_barcode"
  
  validates :product_stock_size_barcode, :quantity, :unit_cost, :currency_id, presence: true
  
  def update_stock_function
    unless self.update_stock.blank? or !self.update_stock or self.quantity.blank?
      if self.quantity_changed?
        change = self.quantity - (self.quantity_was.nil? ? 0 : self.quantity_was)
        self.product_stock_size.update_attribute :stock, self.product_stock_size.stock + change
      else
        self.product_stock_size.update_attribute :stock, self.product_stock_size.stock + self.quantity
      end
    end
  end
  
end
