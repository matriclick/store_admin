class ProductStockSize < ActiveRecord::Base
  belongs_to :product
  belongs_to :size
  has_one :shopping_cart_item
  
  def generate_barcode
    #Formato Barcode
    barcode = self.id.to_s
    length = barcode.length
    if length < 12
      (12 - length).times do 
        barcode = '0'+barcode
      end
    end
    puts barcode
    return barcode
  end
  
end
