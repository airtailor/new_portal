class Api::ShipmentsController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  before_action :set_order, only: [:show]

  def show
    render :json => @shipment.to_json
  end

  def create
    shipment = Shipment.create(shipment_params)
    if shipment.save
      render :json => shipment.order.as_json(include: [:incoming_shipment, :outgoing_shipment, :customer , :items => {include: [:item_type, :alterations]}])
    else
      render :json => { :errors => shipment.errors.full_messages }
    end
  end

  private

  def set_shipment
    @shipment = shipment.find(params[:id])
  end

  def shipment_params
    params.require(:shipment).permit(:order_id, :type)
  end
end

