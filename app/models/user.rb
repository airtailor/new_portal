class User < ApplicationRecord
  rolify
  #resourcify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin? 
    self.has_role? :admin
  end

  def delete_role(role_name)
    roles.delete(roles.where(:id => self.roles.ids))
  end
end
