class Api::CustomersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :edit, :update, :find_or_create]

  def update
    @customer = Customer.where(id: params[:id]).first
    if @customer
      @customer.assign_attributes(customer_params)
      @customer.set_address(address_params)
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
    # @customer.set_address(address_params)

    if @customer.save
      render :json => @customer.as_json
    else
      render :json => {errors: @customer.errors.full_messages}
    end
  end

  private

  def customer_params
    params.require(:customer).permit(*permitted_customer_fields)
  end

  def permitted_customer_fields
    [ :first_name, :last_name, :phone, :email, :agrees_to_terms, :customer ]
  end

end
