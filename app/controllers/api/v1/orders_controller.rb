class Api::V1::OrdersController < Api::V1::ApiController
  before_action :api_authenticate, :set_store, :set_customer

  def create
    @order = Order.new(order_params)
    set_order_defaults
    @order.parse_order_lifecycle_stage

    if @order.save
      set_order_items
      @order.send_shipping_label_email_to_customer
      render :json => @order
    else
      full_messages_error(@order)
    end
  end

  private

  # before actions
  def set_store
    @store = @user.store
  end

  def set_customer
    @customer = Customer.find_or_create_ecomm(customer_params)
    if !@customer.save
      full_messages_error(@customer)
    else
      unless @customer.set_address(address_params)
        render :json => { errors: ["Invalid Address"] }, status: :unprocessable_entity
      end
    end
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
    [ :first_name, :last_name, :phone, :email ]
  end

  def required_address_fields
    [ :street, :city, :state_province, :zip_code ]
  end

  def permitted_address_fields
    fields = [ :street_two, :country, :country_code ]
    return fields + required_address_fields
  end

  def order_params
    params.require(:order).permit(:requester_notes)
  end

  # update order data

  def set_order_defaults
    @order.customer_id = @customer.id
    @order.requester_id = @store.id
    @order.source = "#{@store.company.name} E-commerce"
    @order.total = 0
    @order.weight = 0
    @order.type = TailorOrder
    @order.tailor = @store.default_tailor
  end

  def set_order_items
    items = params.require(:order).require(:items)
    # the order's total and weight is added in the below method
    Item.create_items_ecomm(@order, items)
  end
end
