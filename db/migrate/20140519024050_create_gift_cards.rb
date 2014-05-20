class CreateGiftCards < ActiveRecord::Migration
  def change
    create_table :gift_cards do |t|
      t.integer :customer_id
      t.string :barcode
      t.decimal :amount
      t.datetime :valid_until
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
