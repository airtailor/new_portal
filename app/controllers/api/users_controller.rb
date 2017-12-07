class Api::UsersController < ApplicationController

  def index
    render :json => User.includes(:store, :roles).as_json(
      include: [ :store ], methods: [ :add_valid_roles ]
    )
  end

end
