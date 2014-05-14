class Customer < ActiveRecord::Base
  has_many :purchases
  belongs_to :supplier_account
end
