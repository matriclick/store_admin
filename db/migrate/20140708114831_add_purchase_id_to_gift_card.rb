class AddPurchaseIdToGiftCard < ActiveRecord::Migration
  def change
    add_column :gift_cards, :purchase_id, :integer
  end
end
