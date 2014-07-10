class RestartAllModels < ActiveRecord::Migration
  def change
    Purchase.delete_all
    Product.delete_all
    ProductStockSize.delete_all
    WarehouseProductSizeStock.delete_all
    PettyCash.delete_all
    GiftCard.delete_all
    ShoppingCart.delete_all
    Provider.delete_all
    InventoryReconciliation.delete_all
    ProductReconciliation.delete_all
    PettyCash.delete_all
    Expense.delete_all
    Payment.delete_all
    ShoppingCartItem.delete_all
  end
end
