class ProductCategory < ActiveRecord::Base
  has_and_belongs_to_many :products
  belongs_to :supplier_account
  
  validates :name, presence: true, :uniqueness => {:scope => :supplier_account_id}
end
