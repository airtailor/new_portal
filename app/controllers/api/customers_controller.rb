class Api::CustomersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :edit, :update, :find_or_create, :create_or_validate_customer]
  before_action :set_customer

  def update
    if @customer
      @customer.assign_attributes(customer_params)
      @customer.set_address(address_params)
    else
      errors = ActiveModel::Errors.new(Customer.new)
      errors.add(:id, :not_found, message: "Oops! that customer wasn't found in the db.")
      render :json => {errors: errors.full_messages}
      return
    end

    if @customer.save
      render :json => @customer.as_json
    else
      render :json => {errors: @customer.errors.full_messages}
    end
  end

  def show
    data  = @customer_relation.includes(:addresses)
    render :json => data.as_json(include: [ :addresses ]).first
  end

  def find_or_create
    if @customer.present?
      data  = @customer_relation.includes(:addresses)
      render :json => data.as_json(include: [ :addresses ]).first
    else
      render :json => {status: 404}
    end
  end

  def create_or_validate_customer
    if @customer
      @customer.assign_attributes(customer_params)
    else
      @customer = Customer.new(customer_params)
    end

    if @customer.save
      @customer.set_address(address_params) unless address_params[:street].blank?
      data = Customer.where(id: @customer.id).includes(:addresses)
      render :json => data.as_json(include: [ :addresses ]).first
    else
      render :json => {errors: @customer.errors.full_messages}
    end
  end

  private

  def set_customer
    phone = params[:customer].try(:[], :phone)
    @customer_relation = Customer.where(id: params[:id]).or(Customer.where(phone: phone))
    @customer = @customer_relation.first
  end

  def customer_params
    params.require(:customer).except(:address)
      .permit(*permitted_customer_fields)
  end

  def address_params
    params[:customer].require(:address).permit(*permitted_address_fields)
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
