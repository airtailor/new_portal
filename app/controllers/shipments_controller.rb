class ShipmentsController < ApplicationController
  def make_outgoing_shipment
    byebug
  end

  def make_incoming_shipment
  end

  def create 
    shipment = Shipment.create(shipment_params)
    if shipment.save 
      byebug
      redirect_to store_order_path(current_user.store, shipment.order), notice: "Shipment successfully updated"
    else 
      byebug
      redirect_to store_order_path(current_user.store, shipment.order), alert: "Oops something went wrong"
    end 
  end

  private

  def shipment_params
    params.require(:shipment).permit(:order_id, :type)
  end
end

