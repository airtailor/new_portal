class Api::ShipmentsController < ApplicationController
  def create
    shipment = Shipment.create(shipment_params)
    byebug
    if shipment.save
      redirect_to store_order_path(current_user.store, shipment.order), notice: "Shipment successfully updated"
    else
      redirect_to store_order_path(current_user.store, shipment.order), alert: "Oops something went wrong"
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:order_id, :type)
  end
end

