class SupplierAccount < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :products, :dependent => :destroy
  has_many :sizes, :dependent => :destroy
  has_many :product_categories, :dependent => :destroy
  has_many :purchases, :dependent => :destroy
end
