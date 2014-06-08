class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :symbol
      t.string :name
      t.integer :supplier_account_id

      t.timestamps
    end
  end
end
