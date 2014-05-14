class Purchase < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :shopping_cart
  belongs_to :supplier_account
  belongs_to :customer
end
