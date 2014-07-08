class WarehouseProductSizeStock < ActiveRecord::Base
  belongs_to :warehouse
  belongs_to :product_stock_size
  
end
