class Api::StoresController < ApplicationController
  before_action :authenticate_user!, except: [:create, :update]
  before_action :set_store, only: [:show, :update]

  def index
    render :json => Store.all.as_json
  end

  def show
    render :json => @store_relation.includes(:address).as_json(
      include: [ :address ],
      methods: [
        :active_orders_count,
        :late_orders_count,
        :transit_to_tailor_count
      ]
    ).first
  end

  def update
    @store.assign_attributes(store_params)
    unless @store.set_address(address_params)
      @store.errors.add(:invalid_address, 'Invalid address params.')
    end

    if @store.address.present? && @store.save
      render :json => @store.as_json
    else
      render :json => {errors: @store.errors.full_messages}
    end
  end

  def create
    @store = Store.new(store_params)

    unless @store.set_address(address_params)
      @store.errors.add(:invalid_address, message: 'Invalid address params.')
    end

    if @store.address.present? && @store.save
      render :json => @store.as_json
    else
      render :json => {errors: @store.errors.messages}
    end
  end

  def orders_count
    @store = current_user.store
    render :json =>  {
      active_orders_count: @store.active_orders_count,
      late_orders_count: @store.late_orders_count
    }
  end

  private

  def set_store
    @store_relation = Store.where(id: params[:id])
    @store = @store_relation.first
  end

  def store_params
    params.require(:store).except(:address).permit(*permitted_store_fields)
  end

  def address_params
    params[:store].require(:address).permit(*permitted_address_fields)
  end

  def permitted_store_fields
    [ :name, :phone, :company_id, :default_tailor_id, :type, :agrees_to_terms ]
  end

  def required_address_fields
    [ :street, :city, :state_province, :zip_code ]
  end

  def permitted_address_fields
    fields = [ :street_two, :number, :country, :country_code, :unit, :floor ]

    return fields + required_address_fields
  end
end
