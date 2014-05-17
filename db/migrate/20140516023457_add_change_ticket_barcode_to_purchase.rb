class AddChangeTicketBarcodeToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :change_ticket_barcode, :string
  end
end
