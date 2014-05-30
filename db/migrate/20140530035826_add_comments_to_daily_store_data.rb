class AddCommentsToDailyStoreData < ActiveRecord::Migration
  def change
    add_column :daily_store_data, :comments, :text
  end
end
