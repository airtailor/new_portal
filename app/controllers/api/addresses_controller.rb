class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer
  before_action :set_store

  # NOTE: not used, currently. This needs to make addresses intelligently.

  def show
    @address = Address.where(customer: @customer).first
    @address ||= Address.where(store: @store).first

    if @address
      render :json => @address.as_json
    else
      render :json => {errors: "Address not found."}
    end
  end

  def create
    @address = @customer.addresses.build(address_params)
    if @address.save
      render :json => @address.as_json
    else
      render :json => {errors: @address.errors.full_messages}
    end
  end

  def update
    @address = Address.where(id: params[:address_id]).first
    if @address.update(address_params)
      render :json => @address.as_json
    else
      render :json => {errors: "Address not found."}
    end
  end

  private

  def set_customer
    @customer = Customer.where(id: params[:customer_id]).first
  end

  def set_store
    @store = Store.where(id: params[:store_id]).first
  end

  def address_params
    params.require(*required_address_fields).permit(*permitted_address_fields)
  end

  def required_address_fields
    [ :street, :city, :state_province, :zip_code ]
  end

  def permitted_address_fields
    fields = [ :street_two, :number, :country, :country_code, :unit, :floor ]

    return fields + required_address_fields
  end

end
