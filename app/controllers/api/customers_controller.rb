class Api::CustomersController < ApplicationController
  #before_action :authenticate_user!
  before_action :authenticate_user!, except: [:new, :create, :edit, :update]
  before_action :set_customer, only: [:update]

  def update
    if @customer.update(customer_params)
      render :json => @customer.as_json
    else
      byebug
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end
  
  def customer_params
    params.require(:customer).permit(:email, :first_name, :last_name, :phone, :email, :street1, :street2, :city, :state, :zip)
  end
end
