class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
          #:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  
  def confirmed_at
    Time.now.utc
  end
  rolify
  #resourcify

  # before_validation :set_provider
  # before_validation :set_uid

  # def set_provider
  #   self.provider = "email" if self.provider.blank?
  # end

  # def set_uid
  #   self.uid = self.email if self.uid.blank? && self.email.present?
  # end

  belongs_to :store, optional: true

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

  def update_password(params)
    password, password_confirmation = params.values_at(:password, :password_confirmation)
    if password === password_confirmation
      self.update_attributes(password: password)
    end
  end

  # includes user roles when sending out user after succesful sign in : )
  def token_validation_response
    self.as_json(include: :roles)
  end
end
