class Overrides::TokenValidationsController < DeviseTokenAuth::TokenValidationsController

  def validate_token
    super do |user|
      user.valid_roles = user.roles.inject({}) do |permissions, role|
        permissions[role.name] = true
        permissions
      end
    end
  end
end
