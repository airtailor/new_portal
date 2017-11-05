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
    # the front-end should pass an arr
    @shipment.orders = Order.where(id: [ params[:shipment][:order_id] ])

    shipment_action = params[:shipment][:shipment_action]
    @shipment.set_delivery_method(shipment_action)
    @shipment.set_default_fields

    if @shipment.deliver && @shipment.save
      #@shipment.text_all_shipment_customers
      render :json => @shipment.as_json
    else
      render :json => { :errors => @shipment.errors.full_messages }
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:delivery_type)
  end
end
