class DeleteAllProductsAndPuchasesFromDatabase < ActiveRecord::Migration
  def change
    Purchase.all.destroy_all
    ProductStockSize.all.destroy_all
    Product.all.destroy_all
  end
end
