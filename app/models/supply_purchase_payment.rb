class SupplyPurchasePayment < ActiveRecord::Base
  belongs_to :supply_purchase
  belongs_to :currency
  
  validates :pay_date, :currency_id, :amount, presence: true
end
