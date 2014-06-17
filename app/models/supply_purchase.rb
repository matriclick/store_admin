class SupplyPurchase < ActiveRecord::Base
  belongs_to :provider
  has_many :supply_purchase_product_sizes
  has_many :product_stock_sizes, through: :supply_purchase_product_sizes
  
  accepts_nested_attributes_for :supply_purchase_product_sizes, :allow_destroy => true
  
end
