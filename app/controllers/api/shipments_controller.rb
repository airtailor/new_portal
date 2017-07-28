class Api::ShipmentsController < ApplicationController
  def create
    shipment = Shipment.create(shipment_params)
    if shipment.save
      render :json => shipment.to_json
    else
      render :json => { :errors => shipment.errors.full_messages }
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:order_id, :type)
  end
end

