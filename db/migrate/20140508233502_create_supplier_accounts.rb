class CreateSupplierAccounts < ActiveRecord::Migration
  def change
    create_table :supplier_accounts do |t|
      t.string :name

      t.timestamps
    end
  end
end
