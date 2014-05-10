class AddSupplierAccountIdToProductCategory < ActiveRecord::Migration
  def change
    add_column :product_categories, :supplier_account_id, :integer
  end
end
