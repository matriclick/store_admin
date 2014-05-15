require 'barby'
require 'barby/barcode/ean_13'

class SupplierAccount < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :customers, :dependent => :destroy
  has_many :warehouses, :dependent => :destroy
  has_many :daily_store_data, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_many :sizes, :dependent => :destroy
  has_many :product_categories, :dependent => :destroy
  has_many :purchases, :dependent => :destroy
  has_many :daily_store_datum, :dependent => :destroy
  
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
  
  def get_purchases(from, to, q)
    if q.blank?
      return self.purchases.where('purchases.created_at >= ? and purchases.created_at <= ?', from, to).order 'purchases.created_at DESC'
    else
      return self.purchases.where('id = ? or buyer_email like "%'+q+'%"', q).order 'purchases.created_at DESC'
    end
  end
  
  private

    def is_number?(object)
      true if Float(object) rescue false
    end

end
