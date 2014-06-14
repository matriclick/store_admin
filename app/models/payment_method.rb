class PaymentMethod < ActiveRecord::Base
  has_many :payments
  belongs_to :supplier_account
end
