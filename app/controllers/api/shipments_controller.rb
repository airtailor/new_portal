class Api::ShipmentsController < ApplicationController
  before_action :authenticate_user!, except: [:create]

  def show
    @shipment = Shipment.where(id: params[:id]).first

    if @shipment
      render :json => @shipment.to_json
    else
      render :json => { :errors => "Shipment not found." }
    end
  end

  def create
    # This is where we'd need to make a loop to include bulk shipping.
    @shipment = Shipment.new(shipment_params)

    orders = Order.where(id: params[:shipment][:order_ids])
    @shipment.orders = orders
    @shipment.weight = orders.sum(:weight)
    @shipment.set_delivery_method(params[:shipment][:shipment_action])
    @shipment.deliver

    # and then below, we'd update it to pass all ids to .where and load the associated
    # stuff.
    if @shipment.save
      @shipment.text_all_shipment_customers
      sql_includes = [
        :source, :destination, orders: [ :customer, items: [ :alterations ]]
      ]
      @shipment_relation = Shipment.where(id: @shipment.id).includes(*sql_includes)
      render :json => @shipment_relation.map { |shipment|
                        orders = shipment.orders.as_json(include: [
                          :customer, items: { include: :alterations }
                        ])
                        shipment.as_json(include: [ :source, :destination ])
                          .merge('orders' => orders)
                      }.to_json
    else
      render :json => { :errors => @shipment.errors.full_messages }
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:delivery_type, :shipment_action, order_ids: [])
  end
end
