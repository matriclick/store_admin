class AddGiftCardIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :gift_card_id, :integer
  end
end
