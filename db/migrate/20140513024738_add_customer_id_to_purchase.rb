class AddCustomerIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :customer_id, :integer
  end
end
