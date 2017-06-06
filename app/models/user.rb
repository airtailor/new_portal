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
      .where(id: self.roles.ids))
  end

  def update_roles(user_params)
    if user_params[:admin] == "1"
      self.grant(:admin)
    else user_params[:admin] == "0"
      self.delete_role(:admin)
    end

    if user_params[:tailor] == "1"
      self.grant(:tailor)
    else user_params[:tailor] == "0"
      self.delete_role(:tailor)
    end
  end
end
