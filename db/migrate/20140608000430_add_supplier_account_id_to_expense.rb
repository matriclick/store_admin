class AddSupplierAccountIdToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :supplier_account_id, :integer
  end
end
