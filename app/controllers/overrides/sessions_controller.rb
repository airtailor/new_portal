class Overrides::SessionsController < DeviseTokenAuth::SessionsController

  def create
    super do |user|
      user.valid_roles = user.roles.inject({}) do |permissions, role|
        permissions[role.name] = true
        permissions
      end
    end
  end

end
