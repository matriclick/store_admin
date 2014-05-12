require 'barby'
require 'barby/barcode/ean_13'

class ProductStockSize < ActiveRecord::Base
  after_save :generate_barcode
  belongs_to :product
  belongs_to :size
  has_one :shopping_cart_item
  
  
  def generate_barcode(force = false)
    if self.barcode.blank? or force
      barcode = self.id.to_s
      length = barcode.length
      if length < 12
        (12 - length).times do 
          barcode = '0'+barcode
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
