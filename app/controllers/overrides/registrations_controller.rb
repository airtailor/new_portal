class Overrides::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def create
    super do |user|
      user.add_role(params['role']) if params['role'].in?(['retailer', 'tailor'])
    end
  end

end
