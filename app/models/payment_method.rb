class PaymentMethod < ActiveRecord::Base
  has_many :payments
  belongs_to :supplier_account
  
  validates :name, presence: true, :uniqueness => {:scope => :supplier_account_id}
end
