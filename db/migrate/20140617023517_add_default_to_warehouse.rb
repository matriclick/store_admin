class AddDefaultToWarehouse < ActiveRecord::Migration
  def change
    add_column :warehouses, :default, :boolean
  end
end
