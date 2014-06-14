class DeletePaymentMethodIdFromPurchase < ActiveRecord::Migration
  def change
    remove_column :purchases, :payment_method_id
  end
end
