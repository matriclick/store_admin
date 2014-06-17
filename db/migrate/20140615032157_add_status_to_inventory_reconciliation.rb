class AddStatusToInventoryReconciliation < ActiveRecord::Migration
  def change
    add_column :inventory_reconciliations, :status, :string
  end
end
