class ShipmentsController < ApplicationController
  def make_outgoing_shipment
  end

  def make_incoming_shipment
  end

  private

  def shipment_params
    params.require(:shipment).permit(:order_id)
  end
end
