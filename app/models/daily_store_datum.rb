class DailyStoreDatum < ActiveRecord::Base
  belongs_to :supplier_account
  belongs_to :warehouse
  
  validates :date, presence: true, :uniqueness => {:scope => :supplier_account_id}
  validates :came_in_clients, :warehouse_id, presence: true
end
