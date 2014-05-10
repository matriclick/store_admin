class AddSupplierAccountIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :supplier_account_id, :integer
  end
end
