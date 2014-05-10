class CreateStoreAdminPrivilegesUsers < ActiveRecord::Migration
  def change
    create_table :store_admin_privileges_users, :id => false do |t|
      t.integer :user_id
      t.integer :store_admin_privilege_id
    end
  end
end
