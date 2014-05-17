class Warehouse < ActiveRecord::Base
  belongs_to :supplier_account
  has_many :warehouse_product_size_stocks
  has_many :product_stock_sizes, :through => :warehouse_product_size_stocks
  has_many :products, :through => :product_stock_sizes
end
