class AddSenderEmailToSupplierAccount < ActiveRecord::Migration
  def change
    add_column :supplier_accounts, :sender_email_username, :string
    add_column :supplier_accounts, :sender_email_password, :string
    add_column :supplier_accounts, :sender_email_provider, :string
  end
end
