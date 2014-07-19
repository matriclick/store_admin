class AddTaxExceptionToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :tax_exception, :boolean
    add_column :expenses, :provider_id, :integer
  end
end
