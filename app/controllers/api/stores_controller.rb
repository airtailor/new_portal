class Api::StoresController < ApplicationController
  before_action :authenticate_user!, except: [:create, :update]
  before_action :set_store, only: [:show, :update]

  def show
    #render json: current_user.store
    #if current_user.store.id.to_s == params[:id] && current_user.tailor?
    #    render :json => current_user.store.as_json(methods: [:late_orders_count, :active_orders_count]
    #    )
    #else
    #  render :json => {status: :unprocessable_entity }
    #end
    data = @store.as_json(methods: [:late_orders_count, :active_orders_count, :transit_to_tailor_count])
    render :json => data
  end

  def update
    if @store.update(store_params)
      render :json => @store.as_json
    else
      byebug
    end
  end

  def create
    store = Store.create(store_params)
    if store.save
      render :json => store.as_json
    else
      byebug
    end
  end

  private

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    #if current_user.tailor?
      params.require(:store)
        .permit(
          :name, :phone, :street1, :street2, :city, :state, :zip, :company_id)
    #end
  end
end
