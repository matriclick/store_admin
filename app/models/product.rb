class Product < ActiveRecord::Base
  has_and_belongs_to_many :product_categories
  
  has_many :product_images, :dependent => :destroy
	has_many :product_stock_sizes, :dependent => :destroy
	has_many :sizes, :through => :product_stock_sizes
  belongs_to :supplier_account
  
  accepts_nested_attributes_for :product_images, :allow_destroy => true
	accepts_nested_attributes_for :product_stock_sizes, :allow_destroy => true
	
end
