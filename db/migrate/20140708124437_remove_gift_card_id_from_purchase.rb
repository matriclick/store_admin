class RemoveGiftCardIdFromPurchase < ActiveRecord::Migration
  def change
    remove_column :purchases, :gift_card_id
  end
end
