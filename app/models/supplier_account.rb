require 'barby'
require 'barby/barcode/ean_13'

class SupplierAccount < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :daily_store_data, :dependent => :destroy
  has_many :customers, :dependent => :destroy
  has_many :warehouses, :dependent => :destroy
  has_many :daily_store_data, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_many :sizes, :dependent => :destroy
  has_many :product_categories, :dependent => :destroy
  has_many :purchases, :dependent => :destroy
  has_many :daily_store_datum, :dependent => :destroy
  has_many :providers, :dependent => :destroy
  has_many :expense_types, :dependent => :destroy
  has_many :expenses, :dependent => :destroy
  has_many :currencies, :dependent => :destroy
  has_many :supply_purchases, through: :providers
  has_many :supply_purchase_payments, through: :supply_purchases
  has_many :petty_cashes, :dependent => :destroy
  has_many :payment_methods, :dependent => :destroy
  has_many :gift_cards, :dependent => :destroy
  
  validates :name, presence: true, uniqueness: true
  
  has_attached_file :logo, :styles => { :medium => "300x", :thumb => "100x" }, :use_timestamp => false
	validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'image/x-png', 'image/pjpeg']
	validates_attachment_size :logo, :less_than => 2.megabytes
  
  
  def find_products(q)
    if q.blank?
      return self.products
    else
      q.gsub('.', '').gsub('$', '').gsub!(',', '')
      if is_number?(q)
        begin
          pdz = ProductStockSize.find_by_barcode q
          return self.products.joins(:product_stock_sizes).where('product_stock_sizes.product_id = ?', pdz.product_id).uniq
        rescue Exception => exc
          #Si tira error se está buscando por precio
          return self.products.where('price = ?', q)
        end
      else #If it's not a number, lookup in description, name and color
        return self.products.joins(:product_stock_sizes)
                .where('products.name like "%'+q+'%" or products.description like "%'+q+'%" or product_stock_sizes.color like "%'+q+'%"').uniq
      end
    end
  end
  
  def find_customers(q)
    if q.blank?
      return self.customers
    else
      q.gsub('.', '').gsub!(',', '')
      return self.customers.where('name like "%'+q+'%" or email like "%'+q+'%" or rut like "%'+q+'%"')
    end
  end
  
  def find_product_stock_sizes(q)
    if q.blank?
      return ProductStockSize.joins(:product).where('products.supplier_account_id = ?', self.id)
    else
      q.gsub('.', '').gsub('$', '').gsub!(',', '')
      if is_number?(q)
        begin
          return ProductStockSize.where('barcode = ?', q)
        rescue Exception => exc
          #Si tira error se está buscando por precio
          return  ProductStockSize.joins(:product).where('product.price = ? and products.supplier_account_id = ?', q, self.id)
        end
      else #If it's not a number, lookup in description, name and color
        return ProductStockSize.joins(:product).
              where('products.supplier_account_id = ? and (products.name like "%'+q+'%" or products.description like "%'+q+'%" or product_stock_sizes.color like "%'+q+'%")', self.id)
      end
    end
  end
  
  def find_purchases(from, to, q)
    if q.blank?
      return self.purchases.where('purchases.created_at >= ? and purchases.created_at <= ?', from, to).order 'purchases.created_at DESC'
    else
      return self.purchases.joins(:customer).where('change_ticket_barcode = ? or invoice_number = ? or customers.name like "%'+q+'%"', q, q).order 'purchases.created_at DESC'
    end
  end
  
  private

    def is_number?(object)
      true if Float(object) rescue false
    end

end
