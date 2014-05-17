class AddSupplierAccountIdToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :supplier_account_id, :integer
  end
end
