class PettyCash < ActiveRecord::Base
  belongs_to :user
  belongs_to :supplier_account
  
  validates :close_amount, presence: true
end
