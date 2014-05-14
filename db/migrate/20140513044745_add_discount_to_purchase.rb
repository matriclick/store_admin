class AddDiscountToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :discount, :decimal
  end
end
