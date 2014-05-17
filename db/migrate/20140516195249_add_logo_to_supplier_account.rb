class AddLogoToSupplierAccount < ActiveRecord::Migration
  def self.up
    add_attachment :supplier_accounts, :logo
  end

  def self.down
    remove_attachment :supplier_accounts, :logo
  end
end
