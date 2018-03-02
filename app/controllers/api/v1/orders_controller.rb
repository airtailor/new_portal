class Api::V1::OrdersController < Api::V1::ApiController
  before_action :api_authenticate, :set_store, :set_customer

  def create
    byebug
  end

  private

  # before actions
  def set_store
    @store = @user.store
  end

  def set_customer
    @customer = Customer.find_or_create_by(email: customer_params[:email])
    @customer.update_attributes(customer_params)
    @customer.set_address(address_params)
  end

  # strong params

  def customer_params
    params.require(:order).require(:customer)
      .permit(*permitted_customer_fields)
  end

  def address_params
    params.require(:order).require(:customer)
      .permit(*permitted_address_fields)
  end

  def permitted_customer_fields
    [ :first_name, :last_name, :phone, :email, :agrees_to_01_10_2018, :customer ]
  end

  def required_address_fields
    [ :street, :city, :state_province, :zip_code ]
  end

  def permitted_address_fields
    fields = [ :street_two, :country, :country_code ]
    return fields + required_address_fields
  end

  def order_params
    params.require(:order).permit(
        :requester_notes,
        :weight,
        :total,
        :customer_id => @customer.id,
        :requester_id => @store.id,
        :source => "#{@store.company.name}-ecomm",
        :items => [
          {
            :alterations => [
              { :alteration_id => 1 }
            ]
          }
        ],
        :customer => @customer
      )
  end
end
