class WarehouseProductSizeStock < ActiveRecord::Base
  after_save :delete_if_no_stock
  
  belongs_to :warehouse
  belongs_to :product_stock_size
  
  def delete_if_no_stock
    if self.stock.blank?
      self.destroy
    end
  end
end
