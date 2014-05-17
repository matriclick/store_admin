class AddPurchaseDetailsMailTextToSupplierAccount < ActiveRecord::Migration
  def change
    add_column :supplier_accounts, :purchase_details_mail_text, :text
  end
end
