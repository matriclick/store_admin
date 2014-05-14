class Warehouse < ActiveRecord::Base
  belongs_to :supplier_account
  has_many :product_stock_sizes
  has_many :products, :through => :product_stock_sizes
end
