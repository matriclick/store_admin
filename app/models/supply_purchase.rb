class SupplyPurchase < ActiveRecord::Base
  belongs_to :provider
  has_many :supply_purchase_product_sizes
  has_many :supply_purchase_payments
  has_many :product_stock_sizes, through: :supply_purchase_product_sizes
  
  accepts_nested_attributes_for :supply_purchase_product_sizes, :allow_destroy => true
  accepts_nested_attributes_for :supply_purchase_payments, :allow_destroy => true
  
  validate :has_products?
  validate :has_payments?
  
  def has_products?
    errors.add_to_base "La compra debe tener productos relacionados." if self.supply_purchase_product_sizes.blank?
  end
  
  def has_payments?
    errors.add_to_base "La compra debe tener pagos relacionados." if self.supply_purchase_payments.blank?
  end
end
