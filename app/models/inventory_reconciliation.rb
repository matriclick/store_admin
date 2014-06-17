class InventoryReconciliation < ActiveRecord::Base
  belongs_to :supplier_account
  has_many :product_reconciliations
  has_many :product_stock_sizes, through: :product_reconciliations
  
end
