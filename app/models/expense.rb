class Expense < ActiveRecord::Base
  belongs_to :supplier_account
  belongs_to :expense_type
  belongs_to :currency
  
  validates :currency_id, :amount, :expense_type_id, presence: true
  
end
