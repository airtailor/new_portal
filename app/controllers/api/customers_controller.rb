class Api::CustomersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :edit, :update, :find_or_create]

  def update
    @customer = Customer.where(id: params[:id]).first
    if @customer
      @customer.assign_attributes(customer_params)
      @customer.set_address(params)
    else
      errors = ActiveModel::Errors.new(Customer.new)
      errors.add(:id, :not_found, message: "is not found in DB")
      render :json => {errors: errors.full_messages}
    end

    if @customer.save
      render :json => @customer.as_json
    else
      render :json => {errors: @customer.errors.full_messages}
    end
  end

  def find_or_create
    @customer = Customer.where(phone: customer_params[:phone]).first
    @customer ||= Customer.new

    @customer.assign_attributes(customer_params)
    @customer.set_address(address_params)

    if @customer.save
      render :json => @customer.as_json
    else
      render :json => {errors: @customer.errors.full_messages}
    end
  end

  private

  def customer_params
    params.require(:customer)
      .except(*permitted_address_fields)
      .permit(*permitted_customer_fields)
  end

  def permitted_customer_fields
    [ :first_name, :last_name, :phone, :email, :agrees_to_terms, :customer ]
  end

  def required_address_fields
    [ :street, :city, :state_province, :zip_code ]
  end

  def permitted_address_fields
    fields = [ :street_two, :number, :country, :country_code, :unit, :floor ]

    return fields + required_address_fields
  end
end
