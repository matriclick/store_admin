class AddSupplierAccountIdToPaymentMethod < ActiveRecord::Migration
  def change
    add_column :payment_methods, :supplier_account_id, :integer
  end
end
