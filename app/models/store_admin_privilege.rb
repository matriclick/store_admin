class StoreAdminPrivilege < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  validates :name, presence: true, :uniqueness => {:scope => :supplier_account_id}
end
