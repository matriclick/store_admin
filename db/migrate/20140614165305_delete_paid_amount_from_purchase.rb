class DeletePaidAmountFromPurchase < ActiveRecord::Migration
  def change
    remove_column :purchases, :paid_amount
    Purchase.delete_all
  end
end
