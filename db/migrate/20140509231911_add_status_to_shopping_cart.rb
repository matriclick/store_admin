class AddStatusToShoppingCart < ActiveRecord::Migration
  def change
    add_column :shopping_carts, :status, :string
  end
end
