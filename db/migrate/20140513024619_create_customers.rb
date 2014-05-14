class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :rut
      t.datetime :birthday
      t.string :phone_number
      t.integer :supplier_account_id

      t.timestamps
    end
  end
end
