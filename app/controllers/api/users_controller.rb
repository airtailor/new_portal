class Api::UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    render :json => User.includes(:store, :roles).as_json(
      include: [ :store ], methods: [ :valid_roles ]
    )
  end

end
