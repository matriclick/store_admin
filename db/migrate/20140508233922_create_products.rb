class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.decimal :cost
      t.integer :supplier_account_id

      t.timestamps
    end
  end
end
