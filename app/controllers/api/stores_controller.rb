class Api::StoresController < ApplicationController
  before_action :authenticate_user!, except: [:create, :update]
  before_action :set_store, only: [:show, :update]

  def show
    render :json => @store.as_json(
      methods: [
        :active_orders_count,
        :unread_messages_count,
        :late_orders_count,
        :transit_to_tailor_count
      ]
    )
  end

  def update
    @store.assign_attributes(store_params)
    @store.set_address(store_params)

    if @store.save
      render :json => @store.as_json
    else
      render :json => {errors: @store.errors.full_messages}
    end
  end

  def create
    @store = Store.new(store_params)
    @store.set_address(store_params)

    if @store.save
      render :json => @store.as_json
    else
      byebug
    end
  end

  def orders_and_messages_count
    store = current_user.store
    render :json =>  {
      unread_messages_count: store.unread_messages_count,
      active_orders_count: store.active_orders_count,
      late_orders_count: store.late_orders_count
    }
  end

  private

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    #if current_user.tailor?
    params.require(:store).permit( :name, :phone, :address_data, :company_id )
    #end
  end
end
