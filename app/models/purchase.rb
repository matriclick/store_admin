require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'

class Purchase < ActiveRecord::Base
  after_save :generate_barcode
  
  belongs_to :shopping_cart
  belongs_to :supplier_account
  belongs_to :customer
  belongs_to :user
  has_many :payments
  
  accepts_nested_attributes_for :payments, :allow_destroy => true
    
  def paid_amount
    self.payments.sum(:amount)
  end
  
  def payment_method
    self.payments.each.map { |p| p.payment_method.name }.join ', '
  end
  
  def generate_barcode(force = false)
    if self.change_ticket_barcode.blank? or force
      barcode = self.id.to_s
      length = barcode.length
      if length < 12
        (12 - length).times do 
          barcode = '1'+barcode
        end
      end
      barcode_object = Barby::EAN13.new(barcode) #Automatically adds the checksum digit at the end completing the 13th digit
      self.update_attribute :change_ticket_barcode, barcode_object.to_s
      save_barcode_image(barcode_object)
    end
  end
  
  def reduce_applicable_discount(amount)
    if self.discount.blank? 
      return amount
    else
  	   if self.discount_type == 'absolute' 
  	     return amount - amount*self.discount.to_f/self.shopping_cart.price
  	   elsif self.discount_type == 'percentage' 
  	     return amount*(1-self.discount.to_f/100)
       else
         return amount
       end
    end
  end
  
  private

    def save_barcode_image(barcode_object)
      full_path = "#{Rails.root}/public/system/change_tickets/"+self.supplier_account.name+'/'+self.id.to_s+"_barcode.png"  
      dir = File.dirname(full_path)
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      File.open(full_path, 'w') { |f| f.write barcode_object.to_png(:margin => 3, :height => 55) }
    end
  
end
