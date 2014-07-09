class DeleteAllReconciliations < ActiveRecord::Migration
  def change
    InventoryReconciliation.delete_all
    ProductReconciliation.delete_all
  end
end
