class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable

  include UserConstants
  include DeviseTokenAuth::Concerns::User

  rolify

  belongs_to :store, optional: true

  def confirmed_at
    Time.now.utc
  end

  def valid_roles=(role_hash)
    @valid_roles = role_hash.select do |key, value|
      VALID_ROLES.include?(key.to_s) && [ true, false ].include?(value)
    end
  end

  def valid_roles
    @valid_roles
  end

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
    if self.valid_roles
      super.merge('valid_roles' => self.valid_roles)
    else
      super
    end
  end
end
