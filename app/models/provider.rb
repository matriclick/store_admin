class Provider < ActiveRecord::Base
  belongs_to :supplier_account
  has_many :supply_purchases
end
