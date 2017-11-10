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
    @shipment.orders = Order.where(id: params[:shipment][:order_ids])
    @shipment.set_delivery_method(params[:shipment][:shipment_action])
    @shipment.set_default_fields
    @shipment.deliver

    if @shipment.save
      #@shipment.text_all_shipment_customers
      # pass the correct fucking address type here. god damn it. fucking hell.
      data = @shipment.as_json(include: [ :source, :destination ])
      Rails.logger.debug(data)
      render :json => data
      # render :json => { destination_address_class: @shipment.destination_address}

    else
      render :json => { :errors => @shipment.errors.full_messages }
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:delivery_type, :shipment_action, order_ids: [])
  end
end
