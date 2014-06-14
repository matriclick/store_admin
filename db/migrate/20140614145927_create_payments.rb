class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :purchase_id
      t.integer :payment_method_id
      t.decimal :amount

      t.timestamps
    end
  end
end
