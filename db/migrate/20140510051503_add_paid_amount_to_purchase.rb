class AddPaidAmountToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :paid_amount, :decimal
  end
end
