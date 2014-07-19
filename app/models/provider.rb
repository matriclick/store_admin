class Provider < ActiveRecord::Base
  belongs_to :supplier_account
  has_many :products
  has_many :expenses
  
  validates :name, presence: true, :uniqueness => {:scope => :supplier_account_id}
end
