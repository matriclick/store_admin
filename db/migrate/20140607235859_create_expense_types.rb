class CreateExpenseTypes < ActiveRecord::Migration
  def change
    create_table :expense_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
