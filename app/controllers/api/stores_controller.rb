class Api::StoresController < ApplicationController
  before_action :authenticate_user!
  def show
    #render json: current_user.store
    if current_user.tailor?
      render :json => current_user.store.as_json(include: 
        [:new_orders, :late_orders, :current_orders]
      )
    end
  end
end