class ProductReconciliation < ActiveRecord::Base
  belongs_to :inventory_reconciliation
  belongs_to :product_stock_size
end
