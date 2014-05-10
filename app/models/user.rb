class User < ActiveRecord::Base
  belongs_to :role
  has_and_belongs_to_many :supplier_accounts
  has_and_belongs_to_many :store_admin_privileges
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def is_admin?
    if !self.role.nil? and self.role.name == "Admin"
      return true
    else
      return false
    end
  end
end
