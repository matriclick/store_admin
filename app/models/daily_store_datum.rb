class DailyStoreDatum < ActiveRecord::Base
  belongs_to :supplier_account
  
  validates :date, presence: true, :uniqueness => {:scope => :supplier_account_id}
  validates :came_in_clients, presence: true
end
