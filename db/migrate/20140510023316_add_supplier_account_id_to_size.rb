class AddSupplierAccountIdToSize < ActiveRecord::Migration
  def change
    add_column :sizes, :supplier_account_id, :integer
  end
end
