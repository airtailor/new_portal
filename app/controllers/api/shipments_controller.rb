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
    @shipment = Shipment.new(shipment_params)

    orders = Order.where(id: params[:shipment][:order_ids])
    @shipment.orders = orders
    @shipment.weight = orders.sum(:weight)
    @shipment.set_delivery_method(params[:shipment][:shipment_action])
    @shipment.deliver

    if @shipment.save
      @shipment.text_all_shipment_customers
      render :json => @shipment.as_json(include: [ :source, :destination ])
    else
      render :json => { :errors => @shipment.errors.full_messages }
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:delivery_type, :shipment_action, order_ids: [])
  end
end
