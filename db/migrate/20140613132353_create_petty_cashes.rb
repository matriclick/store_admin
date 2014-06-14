class CreatePettyCashes < ActiveRecord::Migration
  def change
    create_table :petty_cashes do |t|
      t.datetime :close_date
      t.decimal :close_amount
      t.integer :supplier_account_id
      t.integer :user_id

      t.timestamps
    end
  end
end
