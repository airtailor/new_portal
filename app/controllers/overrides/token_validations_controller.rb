class Overrides::TokenValidationsController < DeviseTokenAuth::TokenValidationsController

  def validate_token
    # we need to add a permissions flag to user here.
    # is that safe? we want it to overwrite with the DB values on every request.
    # so that if anybody wanted to do anything, we'd be constantly overwriting it with
    # whatever's in the DB.
    super do |resource|

      user_roles = resource.roles
      permissions = user_roles.inject({}) do |permissions, role|
        permissions[role.name] = true
        permissions
      end
    end
  end

end
