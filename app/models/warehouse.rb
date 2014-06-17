class Warehouse < ActiveRecord::Base
  before_save :check_default
  
  belongs_to :supplier_account
  has_many :warehouse_product_size_stocks
  has_many :product_stock_sizes, :through => :warehouse_product_size_stocks
  has_many :products, :through => :product_stock_sizes
  
  def check_default
    warehouses = Warehouse.where(default: true)
    if warehouses.size == 0
      self.default = true
    elsif self.default
      warehouses.each do |warehouse|
        warehouse.update_attribute :default, false
      end
    end    
  end
  
end
