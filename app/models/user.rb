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

  def tailor? 
    self.has_role? :tailor 
  end

  def delete_role(role_name)
    roles.delete(roles.where(name: role_name)
      .where(:id => self.roles.ids))
  end
end
