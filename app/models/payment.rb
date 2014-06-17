class Payment < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :purchase
  
  validates :payment_method_id, :amount, presence: true
end
