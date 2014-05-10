class CreateStoreAdminPrivileges < ActiveRecord::Migration
  def change
    create_table :store_admin_privileges do |t|
      t.string :name

      t.timestamps
    end
  end
end
