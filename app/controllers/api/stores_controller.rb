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
    @store.update_address(address_params)

    if @store.save
      render :json => @store.as_json
    else
      render :json => {errors: @store.errors.full_messages}
    end
  end

  def create
    @store = Store.new(store_params)
    @store.set_address(address_params)

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
      params.require(:store)
        .except(*permitted_address_fields)
        .permit(*permitted_store_fields)
    #end
  end

  def permitted_store_fields
    [ :name, :phone, :company_id ]
  end

  def address_params
    required_address_fields.each do |field|
      params.require(:customer).require(field)
    end

    params.require(:customer)
      .except(*permitted_customer_fields)
      .permit(*permitted_address_fields)
  end

  def required_address_fields
    [ :street, :city, :state_province, :zip_code ]
  end

  def permitted_address_fields
    fields = [ :street_two, :number, :country, :country_code, :unit, :floor ]

    return fields + required_address_fields
  end
end
