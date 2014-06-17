class Currency < ActiveRecord::Base
  belongs_to :supplier_account
  
  validates :symbol, :name, presence: true, :uniqueness => {:scope => :supplier_account_id}
  
end
