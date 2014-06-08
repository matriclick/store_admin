class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.decimal :amount
      t.integer :currency_id
      t.integer :expense_type_id
      t.string :paid_by
      t.datetime :pay_date
      t.boolean :paid
      t.text :comments

      t.timestamps
    end
  end
end
