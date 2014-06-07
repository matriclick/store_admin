class RemoveCostFieldFromProduct < ActiveRecord::Migration
  def change
    remove_column :products, :cost
  end
end
