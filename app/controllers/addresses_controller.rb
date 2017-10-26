class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer

  def show
    @address = Address.where(customer: @customer).first

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
    if current_user.is_a? Customer
      @customer = current_user.customer
    else
      @customer = Customer.where(id: params[:customer_id]).first
    end
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
