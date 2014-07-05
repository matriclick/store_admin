class AddAddressToSupplierAccount < ActiveRecord::Migration
  def change
    add_column :supplier_accounts, :address, :string
  end
end
