class Size < ActiveRecord::Base
  has_many :products
  has_many :product_stock_sizes, :dependent => :destroy
  belongs_to :supplier_account
  
  validates :name, presence: true, :uniqueness => {:scope => :supplier_account_id}
end
