class AddInvoiceNumberToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :invoice_number, :string
  end
end
