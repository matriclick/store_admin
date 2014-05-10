class CreateSupplierAccountsUsers < ActiveRecord::Migration
  def change
    create_table :supplier_accounts_users, :id => false do |t|
      t.integer :user_id
      t.integer :supplier_account_id
    end
  end
end