class SupplyPurchasePayment < ActiveRecord::Base
  belongs_to :supply_purchase
  belongs_to :currency
end
