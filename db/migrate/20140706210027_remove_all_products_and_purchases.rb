class RemoveAllProductsAndPurchases < ActiveRecord::Migration
  def change
    Purchase.delete_all
    Product.delete_all
    ProductStockSize.delete_all
    WarehouseProductSizeStock.delete_all
    PettyCash.delete_all
    GiftCard.delete_all
    ShoppingCart.delete_all
    Provider.delete_all
    SupplyPurchase.delete_all
    SupplyPurchasePayment.delete_all
    SupplyPurchaseProductSize.delete_all
  end
end
