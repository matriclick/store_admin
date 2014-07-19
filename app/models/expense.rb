class Expense < ActiveRecord::Base
  belongs_to :supplier_account
  belongs_to :expense_type
  belongs_to :currency
  belongs_to :provider
    
  validates :currency_id, :amount, :expense_type_id, :pay_date, presence: true
  
end
