class PettyCash < ActiveRecord::Base
  belongs_to :user
  belongs_to :supplier_account
end
