require 'csv'
class Product < ActiveRecord::Base
  after_save :distribute_stock
  
  has_and_belongs_to_many :product_categories
  has_many :product_images, :dependent => :destroy
	has_many :product_stock_sizes, :dependent => :destroy
	has_many :sizes, :through => :product_stock_sizes
  belongs_to :supplier_account
  
  accepts_nested_attributes_for :product_images, :allow_destroy => true
	accepts_nested_attributes_for :product_stock_sizes, :allow_destroy => true
	
	def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Product.create! row.to_hash
    end
  end
  
  def distribute_stock
    self.product_stock_sizes.each do |psz|
      self.supplier_account.warehouses.each do |warehouse|
        if WarehouseProductSizeStock.where("product_stock_size_id = ? and warehouse_id = ?", psz.id, warehouse.id).size == 0
          WarehouseProductSizeStock.create(:product_stock_size_id => psz.id, :warehouse_id => warehouse.id)
        end
      end
    end
  end
end
