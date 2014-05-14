class AddDiscountTypeToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :discount_type, :string
  end
end
