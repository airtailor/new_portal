class Api::CustomersController < ApplicationController
  #before_action :authenticate_user!
  before_action :authenticate_user!, except: [:new, :create, :edit, :update, :find_or_create]
  before_action :set_customer, only: [:update]

  def update
    if @customer.update(customer_params)
      render :json => @customer.as_json
    else
      render :json => {errors: @customer.errors.full_messages}
    end
  end

  def find_or_create
    customer = Customer.find_or_create_by(phone: params[:customer][:phone])
    customer.update_attributes(customer_params)
    unless customer.errors.blank?
      errors = [
        "Oops. That email belongs to a different phone number."
      ]
      render :json => {errors: {customer: errors}}
    else
      render :json => customer.as_json
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(
      :email,
      :first_name,
      :last_name,
      :address_data
      :phone,
      :agrees_to_terms
    )
  end
end
