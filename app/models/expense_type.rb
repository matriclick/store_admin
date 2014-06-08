class ExpenseType < ActiveRecord::Base
  belongs_to :supplier_account
  has_many :expenses, :dependent => :destroy
end
