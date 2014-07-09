class Provider < ActiveRecord::Base
  belongs_to :supplier_account
  has_many :products
  
  validates :name, presence: true, :uniqueness => {:scope => :supplier_account_id}
end
