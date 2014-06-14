class Payment < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :purchase
end
