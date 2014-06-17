class ExpenseType < ActiveRecord::Base
  belongs_to :supplier_account
  has_many :expenses, :dependent => :destroy
  
  validates :name, presence: true, :uniqueness => {:scope => :supplier_account_id}
end
