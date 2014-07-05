class AddPaymentTypeToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :payment_type, :string
  end
end
