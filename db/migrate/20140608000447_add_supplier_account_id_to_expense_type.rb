class AddSupplierAccountIdToExpenseType < ActiveRecord::Migration
  def change
    add_column :expense_types, :supplier_account_id, :integer
  end
end
