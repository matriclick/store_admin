class RemoveBuyerEmailFromPurchase < ActiveRecord::Migration
  def change
     remove_column :purchases, :buyer_email
     add_column :purchases, :user_id, :integer
  end
end
