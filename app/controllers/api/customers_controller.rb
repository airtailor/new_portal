class Api::CustomersController < ApplicationController
  #before_action :authenticate_user!
  before_action :authenticate_user!, except: [:new, :create, :edit, :update, :find_or_create]
  before_action :set_customer, only: [:update]

  def update
    if @customer.update(customer_params)
      @customer.set_address(customer_params)
      render :json => @customer.as_json
    else
      render :json => {errors: @customer.errors.full_messages}
    end
  end

  def find_or_create
    @customer = Customer.find_or_create_by(phone: params[:customer][:phone])
    @customer.update_attributes(customer_params)
    unless @customer.errors.blank?
      errors = [
        "Oops. That email belongs to a different phone number."
      ]
      render :json => {errors: {customer: errors}}
    else
      @customer.set_address(customer_params)
      render :json => @customer.as_json
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(
      :first_name,
      :last_name,
      :phone,
      :email,
      :street1,
      :street2,
      :city,
      :state,
      :zip,
      :agrees_to_terms
    )
  end
end
