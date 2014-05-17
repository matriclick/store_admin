class AddStoreWebToSupplierAccount < ActiveRecord::Migration
  def change
    add_column :supplier_accounts, :store_web, :string
  end
end
