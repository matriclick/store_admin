class AddInternalCodeToProduct < ActiveRecord::Migration
  def change
    add_column :products, :internal_code, :string
  end
end
