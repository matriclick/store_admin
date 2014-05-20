require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'

class ProductStockSize < ActiveRecord::Base
  after_save :generate_barcode
  
  belongs_to :product
  belongs_to :size
  belongs_to :warehouse
  has_many :shopping_cart_items
  has_many :shopping_carts, through: :shopping_cart_items
  has_many :supply_purchase_product_size
  has_many :warehouse_product_size_stock
  
  def string_for_select
    return self.product.name+' '+self.size.name+' '+self.color
  end
  
  def generate_barcode(force = false)
    if self.barcode.blank? or force
      pdzs = ProductStockSize.where('product_id = ? and color = ? and size_id = ?', self.product_id, self.color, self.size_id)
      if pdzs.size > 1
        barcode = pdzs.first.barcode[0..11]
      else
        barcode = pdzs.first.id.to_s
      end
      length = barcode.length
      if length < 12
        (12 - length).times do 
          barcode = '1'+barcode
        end
      end
      barcode_object = Barby::EAN13.new(barcode) #Automatically adds the checksum digit at the end completing the 13th digit
      self.update_attribute :barcode, barcode_object.to_s
      save_barcode_image(barcode_object)
    end
  end
  
  def assign_manual_barcode(barcode)
    if barcode.size == 13
      barcode_object = Barby::EAN13.new(barcode[0..11]) #Automatically adds the checksum digit at the end completing the 13th digit
      if barcode_object.to_s[12] == barcode[12]
        self.update_attribute :barcode, barcode_object.to_s
        save_barcode_image(barcode_object)
      else
        return false
      end
    else
      return false
    end
  end
  
  private
  
      def save_barcode_image(barcode_object)
        full_path = "#{Rails.root}/public/system/barcodes/"+self.product.supplier_account.name+'/'+self.size.name+'_'+self.color+'_'+self.product.id.to_s+"_barcode.png"  
        dir = File.dirname(full_path)
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        File.open(full_path, 'w') { |f| f.write barcode_object.to_png(:margin => 3, :height => 55) }
      end
  
end
