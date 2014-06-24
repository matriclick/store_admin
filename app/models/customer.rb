class Customer < ActiveRecord::Base
  has_many :purchases
  belongs_to :supplier_account
  
  validates :email, :uniqueness => {:scope => :supplier_account_id}
  validates :name, presence: true
  
end
