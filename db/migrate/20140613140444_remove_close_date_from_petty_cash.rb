class RemoveCloseDateFromPettyCash < ActiveRecord::Migration
  def change
    remove_column :petty_cashes, :close_date
  end
end
