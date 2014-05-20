class AddSupplierAccountIdToGiftCard < ActiveRecord::Migration
  def change
    add_column :gift_cards, :supplier_account_id, :integer
  end
end
