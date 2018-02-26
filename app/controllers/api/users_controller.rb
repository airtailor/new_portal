class Api::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    render :json => User.includes(:store, :roles).as_json(
      include: [ :store ], methods: [ :valid_roles ], exclude: [ :api_key ]
    )
  end

end
