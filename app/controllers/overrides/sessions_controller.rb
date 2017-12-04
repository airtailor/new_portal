class Overrides::SessionsController < DeviseTokenAuth::SessionsController

  def create
    super do |user|
      user.add_valid_roles
    end
  end

end
