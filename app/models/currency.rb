class Currency < ActiveRecord::Base
  belongs_to :supplier_account
end
