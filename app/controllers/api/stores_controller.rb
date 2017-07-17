class Api::StoresController < ApplicationController
  before_action :authenticate_user!
  def show
    #render json: current_user.store
    if current_user.store.id.to_s == params[:id] && current_user.tailor?
        render :json => current_user.store.as_json(methods: [:late_orders_count, :active_orders_count]
        )
    else
      render :json => {status: :unprocessable_entity }
    end
  end
end
