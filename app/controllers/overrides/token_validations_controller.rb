class Overrides::TokenValidationsController < DeviseTokenAuth::TokenValidationsController

  def validate_token
    super do |user|
      user.add_valid_roles
    end
  end
end
