class Expense < ActiveRecord::Base
  belongs_to :supplier_account
  belongs_to :expense_type
  belongs_to :currency
end
