class PaymentMethod < ActiveRecord::Base
  has_many :purchases
end
