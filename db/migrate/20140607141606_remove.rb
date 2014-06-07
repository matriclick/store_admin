class Remove < ActiveRecord::Migration
  def change
    remove_column :supply_purchases, :total_paid
    remove_column :supply_purchases, :currency_id
  end
end
